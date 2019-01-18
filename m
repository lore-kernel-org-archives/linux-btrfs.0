Return-Path: <SRS0=o3FP=P2=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=FREEMAIL_FORGED_FROMDOMAIN,
	FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 25826C43387
	for <linux-btrfs@archiver.kernel.org>; Fri, 18 Jan 2019 07:02:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E8A0D20850
	for <linux-btrfs@archiver.kernel.org>; Fri, 18 Jan 2019 07:02:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727167AbfARHC1 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 18 Jan 2019 02:02:27 -0500
Received: from mout.gmx.net ([212.227.17.22]:42309 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726962AbfARHC1 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 18 Jan 2019 02:02:27 -0500
Received: from t460-skr.localnet ([194.94.224.254]) by mail.gmx.com (mrgmx102
 [212.227.17.168]) with ESMTPSA (Nemesis) id 0LfYqz-1hYn1s35FR-00p4SV for
 <linux-btrfs@vger.kernel.org>; Fri, 18 Jan 2019 08:02:25 +0100
From:   Stefan K <shadow_7@gmx.net>
To:     Linux Btrfs <linux-btrfs@vger.kernel.org>
Reply-To: linux-btrfs@vger.kernel.org
Subject: Re: question about creating a raid10
Date:   Fri, 18 Jan 2019 08:02:24 +0100
Message-ID: <2875582.WnnmDmFHSm@t460-skr>
User-Agent: KMail/5.2.3 (Linux/4.9.0-8-amd64; KDE/5.28.0; x86_64; ; )
In-Reply-To: <CAJCQCtTErRwS5Omb4Asob3sYx8Svt4yV8V5so7fcs+2BX8t3Gg@mail.gmail.com>
References: <3318002.5e9V1lv8s4@t460-skr> <1980543.jviTh1pdNs@t460-skr> <CAJCQCtTErRwS5Omb4Asob3sYx8Svt4yV8V5so7fcs+2BX8t3Gg@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V03:K1:qrM7egWlqA2lj2MgJrD0Hv2Je4GAdutxQxTiJQs1FUowCwfPRCH
 xH3sK3UlBn7Fv8hdLI8WLh1jyxogyBhLakNft5oP6b3YWaP05fXntyWrWi9ilji4QOGKtu8
 k+DhttfpQjppnFcbpeVEkTVPgiY/s3ojCgXA75LxFkCZXEzrgG5/6stVme/Q9tdetE9hSDm
 dk/Bcw2/EV+4P2BciU7fA==
X-UI-Out-Filterresults: notjunk:1;V03:K0:aWL/wwyH0fo=:gv6RksprbX0iLKRMjaCwZ3
 T7jnmIwuJC1oFpw1Sc+zBoMIRxlDYn4+iIiNRx45RYehGRGAWiFvpNh6Ys0UDXvrDz7c/4hfr
 0w9OHmOlnU6aUjlMKVmUvfs5Wa1IZyup04zmtbU7UUDStWZKeOPzUrHpohBmjkGgLQ4qOD7tM
 rftI7UAgQNRRvjD3J0MF1LxlsV9BgazPNg8LVe9gLzaPHjSW//uOASsBOHFDaBAeNLEyEv222
 ldbp1n1Gef14KgfO5knAVkgXZD0kk6gQR4D9Ap04s9L0r6y+7JRFd8C5Yg3A9g5pLIbKaolzK
 hxy/OxgGmImSrCwaSv2L/+MJl7qd0R12Hhn7HXSS52mZL/myWtWGsYDnwNbPY2DnBW19aiLuC
 bs73LiwUQP2aGiRLXjSG9UCMmAIt8Avwet81hKr5yCC7Cvb0QmRqc8CUDBvel+87dPTpMVlBO
 RfVyBBi5mMnAvB6P3KlQUmqwbP/h/T4+0QdtWGWEchTxg+qOYHOoFZqt1PdKB45huEsUyj7UQ
 K1woZVZVYzB7u7P+E+QkcaOvfEYJ1hv1F4aEE50q2un30ANqGix93dDDixVbzSexbS0Xvr73c
 Sxba62/gH4iCywknFfvJH7IPdai7300WqXImDhYeyfWXPlWPZhBZ/jw8NYu+WK/pWdd7FZ8lk
 KkRIEbvlVhwHzAlvGwhegs9BjFmzb4B710rW/eDKVqz2ofzKKOHB29CTtU0MXbdOaprfE9l+T
 A3rNTk+gpB9xdqMd/dnZ+WvBk9DDIKpoEl+L0aESbKrqEUPMbELVzKM193aGI91WzXz5wxcA0
 ciR/l/Tgk9ym2IGne2N6E7w9tKOYA9ltNt+0sp3z2l4vmmXbCvdiPJJDjNHRySjMlCbzENdnn
 qGR9cYOGp6DbCpx3I97J/LjPTzgJGER2z+h6hcozuEN3QdRjr2Ily0T327xCx0wmnrZ52PAzR
 F4zGgC/yERQ==
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

> Btrfs raid10 really should not be called raid10. It sets up the wrong
> user expectation entirely. It's more like raid0+1, except even that is
> deceptive because in theory a legit raid0+1 you can lose multiple
> drives on one side of the mirror (but not both); but with Btrfs raid10
> you really can't lose more than one drive. And therefore it does not
> scale. The probability of downtime increases as drives are added;
> whereas with a real raid10 downtime doesn't change.
WTF?! really, so with btrfs raid10 I can't lose more than one drive? that sucks, that an advantage of raid 10!
and the crazy thing is, thats not documented, not in the manpage nor btrfs wiki and and thats is very important.
thats unbelievable ..


> In your case you're better off with raid0'ing the two drives in each
> enclosure (whether it's a feature of the enclosure or doing it with
> mdadm or LVM). And then using Btrfs raid1 on top of the resulting
> virtual block devices. Or do mdadm/LVM raid10, and format it Btrfs. 
mdadm, lvm.. btrfs is a reason to not use this programms, but since btrfs does not have a 'real' raid10 but a raid01 it does not fit in our use case + I can't configure which disk is in which mirror..

On Wednesday, January 16, 2019 11:15:02 AM CET Chris Murphy wrote:
> On Wed, Jan 16, 2019 at 7:58 AM Stefan K <shadow_7@gmx.net> wrote:
> >
> >  :(
> > that means when one jbod fail its there is no guarantee that it works fine? like in zfs? well that sucks
> > Didn't anyone think to program it that way?
> 
> The mirroring is a function of the block group, not the block device.
> And yes that's part of the intentional design and why it's so
> flexible. A real raid10 isn't as flexible, so to enforce the
> allocation of specific block group stripes to specific block devices
> would add complexity to the allocator while reducing flexibility. It's
> not impossible, it'd just come with caveats like no three device
> raid10 like now; and you'd have to figure out what to do if the user
> adds one new device instead of two at a time, and what if any new
> device isn't the same size as existing devices or if you add two
> devices that aren't the same size. Do you refuse to add such devices?
> What limitations do we run into when rebalancing? It's way more
> complicated.
> 
> Btrfs raid10 really should not be called raid10. It sets up the wrong
> user expectation entirely. It's more like raid0+1, except even that is
> deceptive because in theory a legit raid0+1 you can lose multiple
> drives on one side of the mirror (but not both); but with Btrfs raid10
> you really can't lose more than one drive. And therefore it does not
> scale. The probability of downtime increases as drives are added;
> whereas with a real raid10 downtime doesn't change.
> 
> In your case you're better off with raid0'ing the two drives in each
> enclosure (whether it's a feature of the enclosure or doing it with
> mdadm or LVM). And then using Btrfs raid1 on top of the resulting
> virtual block devices. Or do mdadm/LVM raid10, and format it Btrfs. Or
> yeah, use ZFS.
> 
> 

