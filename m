Return-Path: <SRS0=iJ2R=NK=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.7 required=3.0 tests=FREEMAIL_FORGED_FROMDOMAIN,
	FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 12626C6786F
	for <linux-btrfs@archiver.kernel.org>; Tue, 30 Oct 2018 20:11:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C14EE2080A
	for <linux-btrfs@archiver.kernel.org>; Tue, 30 Oct 2018 20:11:05 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org C14EE2080A
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=gmx.de
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726208AbeJaFF7 convert rfc822-to-8bit (ORCPT
        <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 31 Oct 2018 01:05:59 -0400
Received: from mout.gmx.net ([212.227.17.22]:49677 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725926AbeJaFF7 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 31 Oct 2018 01:05:59 -0400
Received: from [192.168.178.22] ([109.193.14.2]) by mail.gmx.com (mrgmx102
 [212.227.17.168]) with ESMTPSA (Nemesis) id 0LyS5K-1fWifI1Q2Q-015rYR for
 <linux-btrfs@vger.kernel.org>; Tue, 30 Oct 2018 21:11:02 +0100
Received: from [192.168.178.22] ([109.193.14.2]) by mail.gmx.com (mrgmx102
 [212.227.17.168]) with ESMTPSA (Nemesis) id 0LyS5K-1fWifI1Q2Q-015rYR for
 <linux-btrfs@vger.kernel.org>; Tue, 30 Oct 2018 21:11:02 +0100
To:     linux-btrfs@vger.kernel.org
From:   Mirko Klingmann <m.klingmann@gmx.de>
Subject: Salvage files from broken btrfs
Openpgp: preference=signencrypt
Autocrypt: addr=m.klingmann@gmx.de; prefer-encrypt=mutual; keydata=
 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
Message-ID: <45c08a5b-231a-744f-90e7-b2a33fd9b051@gmx.de>
Date:   Tue, 30 Oct 2018 21:11:08 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.2.1
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Content-Language: de-DE
X-Provags-ID: V03:K1:t/C/28trdF02wgzV+10BmIO/Ba+BPXDyopIjDtEv4psVJsky++c
 YE6U9kvjN10R7dDWZMVTkCEBHbcnkR2io4+kO+DcCsVHinK3oJfG6HsWiTfeDg2lOhlzVQt
 gTjx5zi68Mz6Mr8ryQF9OqZwOgv50dTur/LG3flaS9IRa4qYg/xfdhey8rbk+f+BDbwdimk
 yPKEEWCtvS+VQ/J1WR/wQ==
X-UI-Out-Filterresults: notjunk:1;V01:K0:L1udlOnQSx0=:9aowHgPy+OxPKddKB+vRUb
 lV8nfIyhBEr7oOfctmoOnbhIoFdjOdldky5U/Yp2PhZvSPtrTV1F4Zs1W+BSohqNgKCk4b6M5
 2rN8X/vYToQBLyxs1brlAvVztJboHCxBaZl2/hCBy4r/2ppa1yEJfs+TvkII48XJI6QxrYTSB
 9nH1X0vLNh3g892KNplDOEhaU81JMfi5XkkKCp664RzdSsJJsZifXtd+Yh26b0pIcuqe0Ryxi
 Rh+k7Q1WhuHCGTXZ+3wyC0ewygiR2d/dcwTpp0MGu7Stc8FSD0/WFL18/0ydLgCa5Sp8+7j53
 SFrR9GA+EABXWjPOqOyJYwKR1K+ZCp6fAXwADp7UfEjhDZ+kxK65bqU36kpMG+EGskciKFgdT
 qJC6TkfHlBgWb8ymAYKC/8alyk4L0Q4iB4BSSPhFklV85qy3mJ7cmqwVX8uu+IJtpWzrSsG1E
 uyoigK6H1zfp544DbHwffXSo/F95eVocQ60IbymBj3Munj7hvVEBmv+xz9YliDF5r10cYTsiw
 ROEuwIG2P71prHjrlNm88/K9gYE3YTWwFB2jJFFJVOyVoAzwSJ3afpWhFGjk7RZYsF8bihVPf
 STPf6RIcJnEFDd20fpEiiRhYDxmst9UUZIdvHEZ+hv3rHj8MGL0Ty0Qo8OhXALCYpvIPiiEAb
 l8VoXlcH7fD1uv8hG847Io6DIQ87+oXO/ZaSWDLekWlJNQ7ilKfEI9yClwbHq8RTxsqFy5Xq8
 KhBxpp6S3ZW0RXIbQUsV1NAZITtz1dlldtygdUrXd70NiIWug1eDwWzlwbhywNbLeEiK2thd1
 huUUQWP5lQ4QwsSo3wkqaaEcIpxj8jMRrCdExnZfWgCVf1rKzA=
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Hi all,

my btrfs root file system on a SD card broke down and did not mount anymore.

In retrospective, I think it reached its endurance, so I know that there
is nothing to repair. All I want to do is to salvage some configuration
and data files from the remains left in my ISO file copy. The SD card is
no longer readable, so all I have is the 30GB "dd" copy of the btrfs
partition.

I also tried some things on the ISO file I later found I shouldn't have
done with the "btrfs" tools, which I think broke the file system in it
even more.

So at this stage, this is the "dmesg" output when trying to mount the
ISO file, which then fails:

[  249.239883] BTRFS: device fsid 4235aa4f-7721-4e73-97f0-7fe0e9a3ce9c
devid 1 transid 1757933 /dev/loop2
[  249.241504] BTRFS info (device loop2): disk space caching is enabled
[  249.275950] BTRFS error (device loop2): bad tree block start 0 20987904
[  249.280936] BTRFS error (device loop2): bad tree block start 0 20987904
[  249.280946] BTRFS error (device loop2): failed to read chunk root
[  249.336291] BTRFS error (device loop2): open_ctree failed

Output of "uname -a":

Linux desinfect 4.13.0-39-generic #44~16.04.1-Ubuntu SMP Thu Apr 5
16:43:10 UTC 2018 x86_64 x86_64 x86_64 GNU/Linux

Output of "btrfs --version":

btrfs-progs v4.4

When reading the ISO file with "Active@ Disk Editor" (a hex file editor)
I find a super block at offset 0x10000 that looks like this:

B8E15DD7000000000000000000000000000000000000000000000000000000004235AA4F77214E7397F07FE0E9A3CE9C000001000000000001000000000000005F42485266535F4DEDD21A00000000000040FF3400000000004040010000000000000E350000000000000000000000000000E02307000000006092F1030000000600000000000000010000000000000000100000004000000040000000100000E2000000A6380E0000000000000000000000000000000000000000006100000000000000000000000001000000000000000000E023070000000000E0230700000000100000001000000010000000000000000000000000000000000000000000000000000000000000000090185CF6B93749BBB19191D08677EE224235AA4F77214E7397F07FE0E9A3CE9C

The super block at offset 0x4000000 is zeroed out.

When looking at the addresses of chunk root (0x1404000), root of tree
root (0x34FF4000) and log tree root (0x350E0000) in the first super
block they are all zeroed out as well. So I think I understand why the
error "failed to read chunk root" crops up.

If I try to "restore" using "btrfs restore sdcard.iso /outdir" I get
this output:

checksum verify failed on 20987904 found E4E3BDB6 wanted 00000000
checksum verify failed on 20987904 found E4E3BDB6 wanted 00000000
checksum verify failed on 20987904 found E4E3BDB6 wanted 00000000
checksum verify failed on 20987904 found E4E3BDB6 wanted 00000000
bytenr mismatch, want=20987904, have=0
Couldn't read chunk root
Could not open root, trying backup super
No valid Btrfs found on sdcard.iso
Could not open root, trying backup super
Superblock bytenr is larger than device size
Could not open root, trying backup super

And, finally, I can see "/etc" someplace near "fstab" in the ISO which
looks like a directory listing as well as content of files I remember,
which tells me, that the data I still in there somewhere.

So, what can I do to get the files I need out of this blob. I am willing
to follow data pointers as described in
https://btrfs.wiki.kernel.org/index.php/On-disk_Format in the hex editor
and copy the data from there.

Can anyone give me any pointers into the ISO file (maybe starting from
the super block) to help me extract the data I need?

Cheers,

Mirko


