Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-oi0-f48.google.com ([209.85.218.48]:33441 "EHLO
        mail-oi0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753282AbcHWPpo (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 23 Aug 2016 11:45:44 -0400
Received: by mail-oi0-f48.google.com with SMTP id c15so201208427oig.0
        for <linux-btrfs@vger.kernel.org>; Tue, 23 Aug 2016 08:45:03 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <B26BAB7E-A049-4730-B7AD-3E906026F25C@visageimaging.com>
References: <FBA93BA3BE574649A3C97265F3CE0D54013A625685@ber-vi4.ad.vi>
 <CAJCQCtQf2bhxWc6+nYoxYz8HquMOsj5hAfTc=5B2w0_1d8U9rQ@mail.gmail.com> <B26BAB7E-A049-4730-B7AD-3E906026F25C@visageimaging.com>
From: Chris Murphy <lists@colorremedies.com>
Date: Tue, 23 Aug 2016 09:45:02 -0600
Message-ID: <CAJCQCtSuiSrLVLVmF9wktcMJqApET0DoOf=_2V=oEb=5sPPTgg@mail.gmail.com>
Subject: Re: btrfs partition fails to mount after power outage
To: Malte Westerhoff <MWesterhoff@visageimaging.com>
Cc: Chris Murphy <lists@colorremedies.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Aug 23, 2016 at 9:19 AM, Malte Westerhoff
<MWesterhoff@visageimaging.com> wrote:
> Hi Chris,
> Thanks for the response.
> Yes, there is one large raid6 on which there is one LVM physical volume, which has four logical volumes that each have a btrfs file system.
> Only one of them fails to mount, the other three are fine (data2...4).
> The RAID itself claims to be clean (see below).
>
> Output of btrfs-show-super attached.
>
> btrfs-find-root is running now for 30 minutes. It has produced the following output so far (but is still running – not sure whether it is hanging or will eventually terminate).
>
> quickstore2:~/btrfs-progs # ./btrfs-find-root  /dev/mapper/VGBIGRAID6-DATA1
> parent transid verify failed on 7375769206784 wanted 52059 found 52028
> parent transid verify failed on 7375769206784 wanted 52059 found 52028
> parent transid verify failed on 7375769206784 wanted 52059 found 52028
> parent transid verify failed on 7375769206784 wanted 52059 found 52028
> Ignoring transid failure
> leaf parent key incorrect 7375769206784
> Superblock thinks the generation is 52059
> Superblock thinks the level is 1


Huh. Well someone who knows more about Btrfs and devices doing the
wrong thing will have to speak up. To me this looks like something got
the commit order wrong, where the superblock has a more recent
generation than any tree generation, as if the metadata for generation
52059 (or even 52058, 52057, or 52056) is not written or not where
it's supposed to be, and yet the superblock was updated.


>>     btrfs-show-super -fa /dev/mapper/VGBIGRAID6-DATA1

Where is this output?



-- 
Chris Murphy
