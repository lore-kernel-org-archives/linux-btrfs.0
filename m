Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-oi0-f45.google.com ([209.85.218.45]:33230 "EHLO
        mail-oi0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754121AbcIDWE3 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Sun, 4 Sep 2016 18:04:29 -0400
Received: by mail-oi0-f45.google.com with SMTP id y2so7586048oie.0
        for <linux-btrfs@vger.kernel.org>; Sun, 04 Sep 2016 15:04:29 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <eme5309cc5-7dc0-40a0-8b0e-318a2a3459ef@laptophendrik>
References: <em54d2d608-3b06-4e46-b795-214cf333e788@laptophendrik>
 <CAJCQCtRDJ0_pEqtNiQWJoibO=QT-TfF8c7RE7KmF0KZU4T-=OA@mail.gmail.com>
 <em6202fbe3-160c-4002-9576-59e892fedcd0@laptophendrik> <em5bdcb5a1-be8c-43a7-a360-87ae4971a5c7@laptophendrik>
 <eme5309cc5-7dc0-40a0-8b0e-318a2a3459ef@laptophendrik>
From: Chris Murphy <lists@colorremedies.com>
Date: Sun, 4 Sep 2016 16:04:28 -0600
Message-ID: <CAJCQCtQEE2hVA9ZQDMuBTGOZpdP7zSiHPxiQ40axg9TwOJgumw@mail.gmail.com>
Subject: Re: Re[4]: btrfs check "Couldn't open file system" after error in transaction.c
To: Hendrik Friedel <hendrik@friedels.name>
Cc: Chris Murphy <lists@colorremedies.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, Sep 4, 2016 at 1:23 PM, Hendrik Friedel <hendrik@friedels.name> wrote:
> Hello,
>
> here the output of btrfsck:
> Checking filesystem on /dev/sdd
> UUID: a8af3832-48c7-4568-861f-e80380dd7e0b
> checking extents
> checking free space cache
> checking fs root
> checking csums
> checking root refs
> checking quota groups
> Ignoring qgroup relation key 24544
> Ignoring qgroup relation key 24610
> Ignoring qgroup relation key 24611
> Ignoring qgroup relation key 25933
> Ignoring qgroup relation key 25934
> Ignoring qgroup relation key 25935
> Ignoring qgroup relation key 25936
> Ignoring qgroup relation key 25937
> Ignoring qgroup relation key 25938
> Ignoring qgroup relation key 25939
> Ignoring qgroup relation key 25939
> Ignoring qgroup relation key 25941
> Ignoring qgroup relation key 25942
> Ignoring qgroup relation key 25958
> Ignoring qgroup relation key 25959
> Ignoring qgroup relation key 25960
> Ignoring qgroup relation key 25961
> Ignoring qgroup relation key 25962
> Ignoring qgroup relation key 25963
> Ignoring qgroup relation key 25964
> Ignoring qgroup relation key 25965
> Ignoring qgroup relation key 25966
> Ignoring qgroup relation key 25966
> Ignoring qgroup relation key 25968
> Ignoring qgroup relation key 25970
> Ignoring qgroup relation key 25971
> Ignoring qgroup relation key 25972
> Ignoring qgroup relation key 25975
> Ignoring qgroup relation key 25976
> Ignoring qgroup relation key 25976
> Ignoring qgroup relation key 25976
> Ignoring qgroup relation key 567172078071971871
> Ignoring qgroup relation key 567172078071971872
> Ignoring qgroup relation key 567172078071971882
> Ignoring qgroup relation key 567172078071971885
> Ignoring qgroup relation key 567172078071971885
> Ignoring qgroup relation key 567172078071971885
> Ignoring qgroup relation key 567172078071971885
> Ignoring qgroup relation key 567172078071971885
> Ignoring qgroup relation key 567172078071971885
> Ignoring qgroup relation key 567172078071971885
> Ignoring qgroup relation key 567172078071971885
> Ignoring qgroup relation key 567172078071971885
> Ignoring qgroup relation key 567172078071971885
> Ignoring qgroup relation key 567172078071971885
> Ignoring qgroup relation key 567172078071971885
> Ignoring qgroup relation key 567172078071971885
> Ignoring qgroup relation key 567172078071971886
> Ignoring qgroup relation key 567172078071971886
> Ignoring qgroup relation key 567172078071971886
> Ignoring qgroup relation key 567172078071971886
> Ignoring qgroup relation key 567172078071971892
> Ignoring qgroup relation key 567172078071971892
> Ignoring qgroup relation key 567172078071971892
> Ignoring qgroup relation key 567172078071971892
> Ignoring qgroup relation key 567172078071971892
> Ignoring qgroup relation key 567172078071971892
> Ignoring qgroup relation key 567172078071971892
> Ignoring qgroup relation key 567172078071971892
> Ignoring qgroup relation key 567172078071971892
> Ignoring qgroup relation key 567172078071971892
> Ignoring qgroup relation key 567172078071971892
> Ignoring qgroup relation key 567172078071971892
> Qgroup is already inconsistent before checking
> Counts for qgroup id: 3102 are different
> our:            referenced 174829252608 referenced compressed 174829252608
> disk:           referenced 174829252608 referenced compressed 174829252608
> our:            exclusive 2899968 exclusive compressed 2899968
> disk:           exclusive 2916352 exclusive compressed 2916352
> diff:           exclusive -16384 exclusive compressed -16384
> Counts for qgroup id: 25977 are different
> our:            referenced 47249391616 referenced compressed 47249391616
> disk:           referenced 47249391616 referenced compressed 47249391616
> our:            exclusive 90222592 exclusive compressed 90222592
> disk:           exclusive 90238976 exclusive compressed 90238976
> diff:           exclusive -16384 exclusive compressed -16384
> Counts for qgroup id: 25978 are different
> our:            referenced 174829252608 referenced compressed 174829252608
> disk:           referenced 174829252608 referenced compressed 174829252608
> our:            exclusive 1064960 exclusive compressed 1064960
> disk:           exclusive 1081344 exclusive compressed 1081344
> diff:           exclusive -16384 exclusive compressed -16384
> Counts for qgroup id: 26162 are different
> our:            referenced 65940500480 referenced compressed 65940500480
> disk:           referenced 65866997760 referenced compressed 65866997760
> diff:           referenced 73502720 referenced compressed 73502720
> our:            exclusive 3991326720 exclusive compressed 3991326720
> disk:           exclusive 3960582144 exclusive compressed 3960582144
> diff:           exclusive 30744576 exclusive compressed 30744576
> found 8423479726080 bytes used err is 1
> total csum bytes: 8206766844
> total tree bytes: 17669144576
> total fs tree bytes: 7271251968
> total extent tree bytes: 683851776
> total csum bytes: 8206766844
> total tree bytes: 17669144576
> total fs tree bytes: 7271251968
> total extent tree bytes: 683851776
> btree space waste bytes: 2859469730
> file data blocks allocated: 16171232772096
> referenced 13512171663360
>
> What does that tell us?
>

Qu might have an idea, I don't. Looks like quotas are enabled, as well
as compression; but I have no idea if they're related to the problem.
I'd expect Qu would still rather have had a btrfs-image before
init-csum-tree and zero log but I'll leave that up to him to answer.


-- 
Chris Murphy
