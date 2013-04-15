Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ob0-f182.google.com ([209.85.214.182]:57010 "EHLO
	mail-ob0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933629Ab3DORXl (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 15 Apr 2013 13:23:41 -0400
Received: by mail-ob0-f182.google.com with SMTP id dn14so197599obc.13
        for <linux-btrfs@vger.kernel.org>; Mon, 15 Apr 2013 10:23:41 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <516C324D.30200@redhat.com>
References: <1366033629-25121-1-git-send-email-danmcgrath.ca@gmail.com>
	<1366033629-25121-2-git-send-email-danmcgrath.ca@gmail.com>
	<CAMQ-g0eYL7Ab0cETWJW66-9e_qzgRR+Kyd++kk4fzD1m464aZg@mail.gmail.com>
	<CAK82gMGSGaNywR=RkEQcNbQiMW5-z2O3ZqkMwKtamEdRH+A7aQ@mail.gmail.com>
	<516C324D.30200@redhat.com>
Date: Mon, 15 Apr 2013 13:23:40 -0400
Message-ID: <CAK82gMGPwJ462VAjg+5S25PccHAqkL29EVR2kXHx7X0haLBB4Q@mail.gmail.com>
Subject: Re: [PATCH] btrfs-progs: No-op when called as fsck.btrfsck
From: Dan McGrath <danmcgrath.ca@gmail.com>
To: Eric Sandeen <sandeen@redhat.com>
Cc: Jan Alexander Steffens <jan.steffens@gmail.com>,
        linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Jan,

It would appear that:

  # fsck -- --repair /dev/storage/lv_btrfs

doesn't work, but if I put the fs-specific-options at the end:

  # fsck /dev/storage/lv_btrfs -- --repair

it works fine. As we were/are discussing on irc, I also have no idea
where the ext4 lines come from. *scratcheshead*

And to save you guys some testing, here is the script I used and some
sample output:

fsck.btrfs:
========
#!/bin/sh -f

# fsck exit codes for convenience
# 0    - No errors
# 1    - Filesystem errors corrected
# 2    - System should be rebooted
# 4    - Filesystem errors left uncorrected
# 8    - Operational error
# 16   - Usage or syntax error
# 32   - Fsck canceled by user request
# 128  - Shared-library error

AUTO=false
while getopts ":aApy" c
do
        case $c in
        a|A|p|y)        AUTO=true; echo "DEBUG: $c";;
        esac
done
eval DEV=\${$#}
if [ ! -e $DEV ]; then
        echo "$0: $DEV does not exist"
        exit 8
fi
if $AUTO; then
        echo "$0: BTRFS file system."
else
        echo "If you wish to check the consistency of an BTRFS filesystem or"
        echo "repair a damaged filesystem, see btrfsck(8)."
fi
exit 0
========

Output:
======
# fsck /dev/storage/lv_btrfs -- --repair
fsck from util-linux 2.20.1
DEBUG: p
DEBUG: a
/sbin/fsck.btrfs: BTRFS file system.

# fsck /dev/storage/lv_btrfs
fsck from util-linux 2.20.1
If you wish to check the consistency of an BTRFS filesystem or
repair a damaged filesystem, see btrfsck(8).

Note the "p" and "a" switches when called with custom fs switches, but
not when called standalone.


On Mon, Apr 15, 2013 at 1:01 PM, Eric Sandeen <sandeen@redhat.com> wrote:
> On 4/15/13 11:45 AM, Dan McGrath wrote:
>> Jan,
>>
>> I got a chance to sit down and dig a little bit deeper into
>> `fsck.xfs`. Here is what I discovered.
>>
>> The "(a|A|y|p)" options in the XFS script appear to be nothing more
>> than the expected `fsck` options that imply automated checks (as is
>> clearly implied by the use of AUTO). While I have yet to specifically
>> test the capitalized "A", my guess is that it matches the "-A" options
>> from fsck(8) for when the system is going through the fstab. The
>> syntax itself appears to assume that the dev name is the last param
>> (as indicated by the argc/$#, which gets eval'd into the DEV
>> variable).
>>
>> After doing some tests with a hacked up version of the `fsck.xfs`
>> script, it would appear that the generic `fsck` script calls each
>> script in order and passes it some parameters to test, since if I pass
>> `fsck` some random/btrfsck switches:
>>
>>   # fsck --repair /dev/storage/lv_btrfs
>>
>> I get an error back from `fsck.ext4`:
>>
>>   fsck from util-linux 2.20.1
>>   fsck.ext4: invalid option -- 'e'
>
> 2 things; from the fsck manpage:
>
>        fsck [-sAVRTMNP] [-C [fd]] [-t fstype] [filesys...]  [--] [fs-specific-options]
>
> so I think you need:
>
> fsck -- --repair /dev/storage/lv_btrfs
>
> But the other issues seems to be that fsck & blkid are autodetecting
> the device as ext4, not btrfs; a separate issue.
>
> -Eric
>
>
