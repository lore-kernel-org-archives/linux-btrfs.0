Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:35530 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750947AbbEZS57 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 26 May 2015 14:57:59 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1YxK31-0004sL-42
	for linux-btrfs@vger.kernel.org; Tue, 26 May 2015 20:57:55 +0200
Received: from pd953eddd.dip0.t-ipconnect.de ([217.83.237.221])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Tue, 26 May 2015 20:57:55 +0200
Received: from holger.hoffstaette by pd953eddd.dip0.t-ipconnect.de with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Tue, 26 May 2015 20:57:55 +0200
To: linux-btrfs@vger.kernel.org
From: Holger =?iso-8859-1?q?Hoffst=E4tte?=
	<holger.hoffstaette@googlemail.com>
Subject: Re: intermittent -ENOSPC errors on btrfs filesystem with 170G free
Date: Tue, 26 May 2015 18:57:48 +0000 (UTC)
Message-ID: <pan.2015.05.26.18.57.48@googlemail.com>
References: <20150526173634.GU11340@wantstofly.org>
	<20150526180820.GG16826@carfax.org.uk>
	<CAJCQCtQsCU9OhSPRjqTS30i8KeC-_aa9SG+qmViA_q5po00QrQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, 26 May 2015 12:18:40 -0600, Chris Murphy wrote:

> Oh yeah easy to miss, but obvious once pointed out:
> 
>> Data, single: total=227.94GiB, used=58.16GiB
> 
> I thought we had automatic deallocation of unused chunks but I guess
> it hasn't landed yet.

It did (in 3.18 IIRC), but that doesn't help with - for whatever reason -
severely unbalanced chunks, i.e. all allocated but each used only a
little bit. Now, how and why that happened..

-h

