Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:56373 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750715Ab3B0J6G (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 27 Feb 2013 04:58:06 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1UAdmL-0006Ga-2C
	for linux-btrfs@vger.kernel.org; Wed, 27 Feb 2013 10:58:25 +0100
Received: from rain.gmane.org ([80.91.229.7])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Wed, 27 Feb 2013 10:58:25 +0100
Received: from eternaleye by rain.gmane.org with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Wed, 27 Feb 2013 10:58:25 +0100
To: linux-btrfs@vger.kernel.org
From: Alex Elsayed <eternaleye@gmail.com>
Subject: Re: lvm volume like support
Date: Wed, 27 Feb 2013 01:57:55 -0800
Message-ID: <kgklb0$g6a$1@ger.gmane.org>
References: <CAPF83msjTJWjWJgJOAWsQ2GoxAC-cZ4GkK_+H11tAyA689KD_w@mail.gmail.com> <CAMU1PDhQqm6s5FUbVJa5nwOD4Ewf-6Cr2gx2khHHwrBxUqsQDA@mail.gmail.com> <CAG1y0scOg2QGCZdCTkKHBn5xxNh5GGmdXTcS8rOesup4r1JsXQ@mail.gmail.com> <201302261130.31494.Martin@lichtvoll.de> <CAG1y0sfYqcZTyHffV=t95R09qyJc911ZE-F-YPM1rKmV1wj7CA@mail.gmail.com> <20130227100558.37d86d82@natsu> <kgkhcp$dfg$1@ger.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Alex Elsayed wrote:

> Roman Mamedov wrote:
> 
>> On Wed, 27 Feb 2013 13:23:23 +1100
>> "Fajar A. Nugraha" <list@fajar.net> wrote:

<snip>

> This could be pretty easily put into a shell script that uses du -b and
> manually pokes configfs instead of calling tcm_node, and it'd be able to
> run without any nonstandard userspace dependencies.

Just for fun, I decided to put my money where my mouth is and implement
a quick scsi-target-losetup that actually worked, both for creation and
deletion. Here it is:

---cut---

#!/bin/bash

gen_naa() {
    local UUID="$( uuidgen -r )"
    UUID="${UUID//-/}"
    UUID="${UUID:0:9}"
    echo "naa.6001405${UUID}"
}

setup() {
    local FILE
    local INPUT_NAME
    local NAME
    local BACKEND_IDX
    local TRANSPORT_IDX
    declare -a NAA
    FILE="${1}"
    INPUT_NAME="${2}"
    NAME="${INPUT_NAME//\//_}"
    BACKEND_IDX='-1'
    TRANSPORT_IDX='-1'

    if [[ $UID -ne 0 ]]; then
        echo "You must be root in order to set up a lioloop device" >&2
        exit 1
    fi

    if [[ "${NAME}" != "${INPUT_NAME}" ]]; then
        echo "The chosen name '${INPUT_NAME}' contained slashes, using '${NAME}' instead" >&2
    fi

    declare SIZE="$(du -b "${FILE}")"
    SIZE="${SIZE/[^0123456789]*}"

    # Load the scsi target core and backends
    modprobe target_core_mod >/dev/null 2>&1

    while BACKEND_IDX=$((BACKEND_IDX + 1)); do
        if [[ -d "/sys/kernel/config/target/core/fileio_${BACKEND_IDX}/${NAME}" ]]; then
            echo "A backstore with the name '${NAME}' already exists" >&2
            exit 1
        elif ! [[ -d /sys/kernel/config/target/core/fileio_${BACKEND_IDX} ]]; then
    #        mkdir -p "/sys/kernel/config/target/core/fileio_${BACKEND_IDX}/${NAME}"
    # Tell it where the file is and how big it is
            tcm_node --establishdev "fileio_${BACKEND_IDX}/${NAME}" \
                "fd_dev_name=${FILE},fd_dev_size=${SIZE}"
    # Give it a unique serial
            tcm_node --setunitserialwithmd "fileio_${BACKEND_IDX}/${NAME}" "$(uuidgen -r)"
            break
        fi
    done

    # Load the local scsi frontend transport
    modprobe tcm_loop >/dev/null 2>&1
    mkdir -p /sys/kernel/config/target/loopback

    NAA=( "$(gen_naa)" "$(gen_naa)" )
    # Some setup so you have a place to put LUNs
    mkdir -p "/sys/kernel/config/target/loopback/${NAA[0]}/tpgt_1"
    echo "${NAA[1]}" > "/sys/kernel/config/target/loopback/${NAA[0]}/tpgt_1/nexus"

    # Create a fresh LUN...
    while TRANSPORT_IDX=$((TRANSPORT_IDX + 1)); do
        if ! [[ -d "/sys/kernel/config/target/loopback/${NAA[0]}/tpgt_1/lun/lun_${TRANSPORT_IDX}" ]]; then
            mkdir -p "/sys/kernel/config/target/loopback/${NAA[0]}/tpgt_1/lun/lun_${TRANSPORT_IDX}"
    # ...and map the file to it.
            ln -s "/sys/kernel/config/target/core/fileio_${BACKEND_IDX}/${NAME}" \
                "/sys/kernel/config/target/loopback/${NAA[0]}/tpgt_1/lun/lun_${TRANSPORT_IDX}"
            break
        fi
    done
}

teardown() {
    local INPUT_NAME="${1}"
    local NAME="${INPUT_NAME//\//_}"

    if [[ $UID -ne 0 ]]; then
        echo "You must be root in order to tear down a lioloop device" >&2
        exit 1
    fi

    if [[ "${NAME}" != "${INPUT_NAME}" ]]; then
        echo "The chosen name '${INPUT_NAME}' contained slashes, using '${NAME}' instead" >&2
    fi

    local FOUND=''
    for LUN in /sys/kernel/config/target/loopback/*/tpgt_1/lun/lun_*; do
        if [[ -L "${LUN}/${NAME}" ]]; then
            rm -f "${LUN}/${NAME}"
            FOUND=1
        fi
    done

    if [[ -z "${FOUND}" ]]; then
        echo "No lioloop with the name '${NAME}' was found" >&2
        return
    fi

    for BACKSTORE in /sys/kernel/config/target/core/fileio_*; do
        if [[ -d "${BACKSTORE}/${NAME}" ]]; then
            rmdir "${BACKSTORE}/${NAME}"
        fi
    done
}

if [[ "$1" == '-d' ]]; then
    shift;
    for name in "$@"; do
        teardown "${name}"
    done
else
    setup "$@"
fi



