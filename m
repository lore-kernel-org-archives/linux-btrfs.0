Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:44651 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751691AbbHYO0k (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 25 Aug 2015 10:26:40 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
	id 1ZUFBO-00057k-Gk
	for linux-btrfs@vger.kernel.org; Tue, 25 Aug 2015 16:26:38 +0200
Received: from h8193.mu.qub.ac.uk ([143.117.78.193])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Tue, 25 Aug 2015 16:26:38 +0200
Received: from miguel.negrao-lists by h8193.mu.qub.ac.uk with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Tue, 25 Aug 2015 16:26:38 +0200
To: linux-btrfs@vger.kernel.org
From: Miguel =?utf-8?b?TmVncsOjbw==?=
	<miguel.negrao-lists@friendlyvirus.org>
Subject: Re: Btrfs tragedy: lack of space for metadata leads to loss of fs.
Date: Tue, 25 Aug 2015 14:26:27 +0000 (UTC)
Message-ID: <loom.20150825T161809-326@post.gmane.org>
References: <loom.20150825T151154-787@post.gmane.org> <55DC74E2.9000909@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Austin S Hemmelgarn <ahferroin7 <at> gmail.com> writes:

> One comment I would like to make about this: I have heard numerous 
> stories of OCZ brand SSD's having significant data corruption issues 
> (along the lines of writes returning successful when they really failed, 
> and blocks that are in use getting randomly erased) that can cause 
> severe data loss and filesystem problems.  While I do think that btrfs 
> needs to be improved when faced with such things, I would not at all be 
> surprised if the SSD was the root cause of the issue.
> 
>


It did have some corruption through its 3 year life time. This was from one
month ago:

sudo btrfs device stats /

[/dev/sda5].write_io_errs   0
[/dev/sda5].read_io_errs    0
[/dev/sda5].flush_io_errs   0
[/dev/sda5].corruption_errs 996
[/dev/sda5].generation_errs 0

On the latest scrub that I took note of the results though, it didn't have
corruption:

sudo btrfs scrub status /
scrub status for f2e4e4d3-2d8e-4764-a818-de9176405c4b
	scrub started at Fri Apr 17 14:42:47 2015 and finished after 146 seconds
	total bytes scrubbed: 66.10GiB with 0 errors

Best regards,
Miguel NegrÃ£oÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±ı»k~ÏâØ^n‡r¡ö¦zËëh™¨è­Ú&£ûàz¿äz¹Ş—ú+€Ê+zf£¢·hšˆ§~†­†Ûiÿÿïêÿ‘êçz_è®æj:+v‰¨ş)ß£øm
