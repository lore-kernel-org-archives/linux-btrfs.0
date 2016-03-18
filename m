Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from know-smtprelay-omc-6.server.virginmedia.net ([80.0.253.70]:52050
	"EHLO know-smtprelay-omc-6.server.virginmedia.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757828AbcCRR6T (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 18 Mar 2016 13:58:19 -0400
Received: from [127.0.0.1] (localhost [127.0.0.1])
	by phoenix.vfire (8.14.9/8.14.5) with ESMTP id u2IHwFCN006559
	for <linux-btrfs@vger.kernel.org>; Fri, 18 Mar 2016 17:58:16 GMT
Subject: Re: Snapshots slowing system
To: linux-btrfs@vger.kernel.org
References: <201603142303.u2EN3qo3011695@phoenix.vfire>
 <pan$a0d0a$9f23433a$f19e4b84$b275dc3f@cox.net>
 <56E88CB2.6020300@petezilla.co.uk> <56E945E9.1050005@gmail.com>
 <56EB1CC7.2000602@petezilla.co.uk>
 <pan$24d34$c6dcbaed$b9940b06$c8b4f058@cox.net> <56EBE8B5.4090705@gmail.com>
From: Pete <pete@petezilla.co.uk>
Message-ID: <56EC41B7.4090706@petezilla.co.uk>
Date: Fri, 18 Mar 2016 17:58:15 +0000
MIME-Version: 1.0
In-Reply-To: <56EBE8B5.4090705@gmail.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 03/18/2016 11:38 AM, Austin S. Hemmelgarn wrote:

> This one is tricky, as it's not very clearly defined in the SMART spec.
>  Most manufacturers just count the total time the head has been loaded.
>  There are some however who count the time the heads have been loaded,
> multiplied by the number of heads.  This value still appears to be
> incorrect though, as combined with the Power_On_Hours, it implies well
> over 1024 heads, which is physically impossible on even a 5.25 inch disk
> using modern technology, even using multiple spindles.  The fact that
> this is so blatantly wrong should be a red flag regarding the disk
> firmware or on-board electronics, which just reinforces what Duncan
> already said about getting a new disk.

Have got a larger SSD on the way as it looked tight.  So annoylingly
wallet has to come out again.

