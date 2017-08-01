Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail1.arhont.com ([178.248.108.132]:60400 "EHLO mail.arhont.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751974AbdHASKI (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 1 Aug 2017 14:10:08 -0400
Date: Tue, 1 Aug 2017 19:09:22 +0100 (BST)
From: "Konstantin V. Gavrilenko" <k.gavrilenko@arhont.com>
To: Peter Grandi <pg@btrfs.list.sabi.co.UK>
Cc: Linux fs Btrfs <linux-btrfs@vger.kernel.org>
Message-ID: <15990599.40.1501611004053.JavaMail.gkos@dynomob>
In-Reply-To: <22912.32415.601826.757780@tree.ty.sabi.co.uk>
References: <33040946.535.1501254718807.JavaMail.gkos@dynomob> <8446582.541.1501260065690.JavaMail.gkos@dynomob> <22907.32175.311827.10738@tree.ty.sabi.co.uk> <19527869.26.1501422186960.JavaMail.gkos@dynomob> <22911.5971.350346.969146@tree.ty.sabi.co.uk> <6022267.255.1501581534233.JavaMail.gkos@dynomob> <22912.32415.601826.757780@tree.ty.sabi.co.uk>
Subject: Re: Btrfs + compression = slow performance and high cpu usage
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

----- Original Message -----
From: "Peter Grandi" <pg@btrfs.list.sabi.co.UK>
To: "Linux fs Btrfs" <linux-btrfs@vger.kernel.org>
Sent: Tuesday, 1 August, 2017 3:14:07 PM
Subject: Re: Btrfs + compression = slow performance and high cpu usage

> Peter, I don't think the filefrag is showing the correct
> fragmentation status of the file when the compression is used.

<SNIP>

As I wrote, "their size is just limited by the compression code"
which results in "128KiB writes". On a "fresh empty Btrfs volume"
the compressed extents limited to 128KiB also happen to be pretty
physically contiguous, but on a more fragmented free space list
they can be more scattered.

KOS: Ok, thanks for pointing it out. I have compared the filefrag -v on another btrfs  that is not fragmented
and see the difference with what is happening on the sluggish one.

5824:   186368..  186399: 2430093383..2430093414:     32: 2430093414: encoded
5825:   186400..  186431: 2430093384..2430093415:     32: 2430093415: encoded
5826:   186432..  186463: 2430093385..2430093416:     32: 2430093416: encoded
5827:   186464..  186495: 2430093386..2430093417:     32: 2430093417: encoded
5828:   186496..  186527: 2430093387..2430093418:     32: 2430093418: encoded
5829:   186528..  186559: 2430093388..2430093419:     32: 2430093419: encoded
5830:   186560..  186591: 2430093389..2430093420:     32: 2430093420: encoded



As I already wrote the main issue here seems to be that we are
talking about a "RAID5 with 128KiB writes and a 768KiB stripe
size". On MD RAID5 the slowdown because of RMW seems only to be
around 30-40%, but it looks like that several back-to-back 128KiB
writes get merged by the Linux IO subsystem (not sure whether
that's thoroughly legal), and perhaps they get merged by the 3ware
firmware only if it has a persistent cache, and maybe your 3ware
does not have one, but you have kept your counsel as to that.


KOS: No I don't have persistent cache. Only the 512 Mb cache on board of a controller, that is 
BBU. If I had additional SSD caching on the controller I would have mentioned it.

I was also under impression, that in a situation where mostly extra large files will be stored on the massive, the bigger strip size would indeed increase the speed, thus I went with with the 256 Kb strip size.  Would I be correct in assuming that the RAID strip size of 128 Kb will be a better choice if one plans to use the BTRFS with compression?

thanks,
kos



<SNIP>
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
