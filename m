Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ve0-f181.google.com ([209.85.128.181]:62962 "EHLO
	mail-ve0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751462Ab3CBGYq (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sat, 2 Mar 2013 01:24:46 -0500
Received: by mail-ve0-f181.google.com with SMTP id d10so3480603vea.40
        for <linux-btrfs@vger.kernel.org>; Fri, 01 Mar 2013 22:24:45 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <kgklb0$g6a$1@ger.gmane.org>
References: <CAPF83msjTJWjWJgJOAWsQ2GoxAC-cZ4GkK_+H11tAyA689KD_w@mail.gmail.com>
	<CAMU1PDhQqm6s5FUbVJa5nwOD4Ewf-6Cr2gx2khHHwrBxUqsQDA@mail.gmail.com>
	<CAG1y0scOg2QGCZdCTkKHBn5xxNh5GGmdXTcS8rOesup4r1JsXQ@mail.gmail.com>
	<201302261130.31494.Martin@lichtvoll.de>
	<CAG1y0sfYqcZTyHffV=t95R09qyJc911ZE-F-YPM1rKmV1wj7CA@mail.gmail.com>
	<20130227100558.37d86d82@natsu>
	<kgkhcp$dfg$1@ger.gmane.org>
	<kgklb0$g6a$1@ger.gmane.org>
Date: Fri, 1 Mar 2013 23:24:45 -0700
Message-ID: <CALFpzo4JnF=OXcFVCDCLAsj61QpG2Mckfd5EXpmJUu0vpT6s5w@mail.gmail.com>
Subject: Re: lvm volume like support
From: Marcus Sorensen <shadowsor@gmail.com>
To: Alex Elsayed <eternaleye@gmail.com>
Cc: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

That's great, but the issue is that usually the block device version
performs better than just creating a file and using it as a raw image
or loop device. Creating a file, then running it through a SCSI target
seems like it's going in the opposite direction.

On Wed, Feb 27, 2013 at 2:57 AM, Alex Elsayed <eternaleye@gmail.com> wrote:
> Alex Elsayed wrote:
>
>> Roman Mamedov wrote:
>>
>>> On Wed, 27 Feb 2013 13:23:23 +1100
>>> "Fajar A. Nugraha" <list@fajar.net> wrote:
>
> <snip>
>
>> This could be pretty easily put into a shell script that uses du -b and
>> manually pokes configfs instead of calling tcm_node, and it'd be able to
>> run without any nonstandard userspace dependencies.
>
> Just for fun, I decided to put my money where my mouth is and implement
> a quick scsi-target-losetup that actually worked, both for creation and
> deletion. Here it is:
>
> ---cut---
>
> #!/bin/bash
>
> gen_naa() {
>     local UUID="$( uuidgen -r )"
>     UUID="${UUID//-/}"
>     UUID="${UUID:0:9}"
>     echo "naa.6001405${UUID}"
> }
>
> setup() {
>     local FILE
>     local INPUT_NAME
>     local NAME
>     local BACKEND_IDX
>     local TRANSPORT_IDX
>     declare -a NAA
>     FILE="${1}"
>     INPUT_NAME="${2}"
>     NAME="${INPUT_NAME//\//_}"
>     BACKEND_IDX='-1'
>     TRANSPORT_IDX='-1'
>
>     if [[ $UID -ne 0 ]]; then
>         echo "You must be root in order to set up a lioloop device" >&2
>         exit 1
>     fi
>
>     if [[ "${NAME}" != "${INPUT_NAME}" ]]; then
>         echo "The chosen name '${INPUT_NAME}' contained slashes, using '${NAME}' instead" >&2
>     fi
>
>     declare SIZE="$(du -b "${FILE}")"
>     SIZE="${SIZE/[^0123456789]*}"
>
>     # Load the scsi target core and backends
>     modprobe target_core_mod >/dev/null 2>&1
>
>     while BACKEND_IDX=$((BACKEND_IDX + 1)); do
>         if [[ -d "/sys/kernel/config/target/core/fileio_${BACKEND_IDX}/${NAME}" ]]; then
>             echo "A backstore with the name '${NAME}' already exists" >&2
>             exit 1
>         elif ! [[ -d /sys/kernel/config/target/core/fileio_${BACKEND_IDX} ]]; then
>     #        mkdir -p "/sys/kernel/config/target/core/fileio_${BACKEND_IDX}/${NAME}"
>     # Tell it where the file is and how big it is
>             tcm_node --establishdev "fileio_${BACKEND_IDX}/${NAME}" \
>                 "fd_dev_name=${FILE},fd_dev_size=${SIZE}"
>     # Give it a unique serial
>             tcm_node --setunitserialwithmd "fileio_${BACKEND_IDX}/${NAME}" "$(uuidgen -r)"
>             break
>         fi
>     done
>
>     # Load the local scsi frontend transport
>     modprobe tcm_loop >/dev/null 2>&1
>     mkdir -p /sys/kernel/config/target/loopback
>
>     NAA=( "$(gen_naa)" "$(gen_naa)" )
>     # Some setup so you have a place to put LUNs
>     mkdir -p "/sys/kernel/config/target/loopback/${NAA[0]}/tpgt_1"
>     echo "${NAA[1]}" > "/sys/kernel/config/target/loopback/${NAA[0]}/tpgt_1/nexus"
>
>     # Create a fresh LUN...
>     while TRANSPORT_IDX=$((TRANSPORT_IDX + 1)); do
>         if ! [[ -d "/sys/kernel/config/target/loopback/${NAA[0]}/tpgt_1/lun/lun_${TRANSPORT_IDX}" ]]; then
>             mkdir -p "/sys/kernel/config/target/loopback/${NAA[0]}/tpgt_1/lun/lun_${TRANSPORT_IDX}"
>     # ...and map the file to it.
>             ln -s "/sys/kernel/config/target/core/fileio_${BACKEND_IDX}/${NAME}" \
>                 "/sys/kernel/config/target/loopback/${NAA[0]}/tpgt_1/lun/lun_${TRANSPORT_IDX}"
>             break
>         fi
>     done
> }
>
> teardown() {
>     local INPUT_NAME="${1}"
>     local NAME="${INPUT_NAME//\//_}"
>
>     if [[ $UID -ne 0 ]]; then
>         echo "You must be root in order to tear down a lioloop device" >&2
>         exit 1
>     fi
>
>     if [[ "${NAME}" != "${INPUT_NAME}" ]]; then
>         echo "The chosen name '${INPUT_NAME}' contained slashes, using '${NAME}' instead" >&2
>     fi
>
>     local FOUND=''
>     for LUN in /sys/kernel/config/target/loopback/*/tpgt_1/lun/lun_*; do
>         if [[ -L "${LUN}/${NAME}" ]]; then
>             rm -f "${LUN}/${NAME}"
>             FOUND=1
>         fi
>     done
>
>     if [[ -z "${FOUND}" ]]; then
>         echo "No lioloop with the name '${NAME}' was found" >&2
>         return
>     fi
>
>     for BACKSTORE in /sys/kernel/config/target/core/fileio_*; do
>         if [[ -d "${BACKSTORE}/${NAME}" ]]; then
>             rmdir "${BACKSTORE}/${NAME}"
>         fi
>     done
> }
>
> if [[ "$1" == '-d' ]]; then
>     shift;
>     for name in "$@"; do
>         teardown "${name}"
>     done
> else
>     setup "$@"
> fi
>
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
