Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from slmp-550-94.slc.westdc.net ([50.115.112.57]:30384 "EHLO
	slmp-550-94.slc.westdc.net" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752462Ab3ENQau convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 14 May 2013 12:30:50 -0400
Content-Type: text/plain; charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 6.3 \(1503\))
Subject: Re: Remove a materially failed device from a Btrfs "single-raid" using partitions
From: Chris Murphy <lists@colorremedies.com>
In-Reply-To: <519258A7.4080503@influence-pc.fr>
Date: Tue, 14 May 2013 10:30:50 -0600
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
Message-Id: <F2289CA7-6CB0-499A-B78A-F79D72115A3C@colorremedies.com>
References: <5190F59F.405@influence-pc.fr> <CAFWF=akT1vSPSXkAKCf9y3Ej63XSmBGC_MZKk0BCRxz2diCHFg@mail.gmail.com> <5190F9C7.1080904@influence-pc.fr> <CAFWF=ak4mKMgNZHx6pxuhY7pCEE0G-aifGNi_zRX5zyAUh7n-g@mail.gmail.com> <5191071B.7090209@influence-pc.fr> <5741BE95-3287-4054-A3AE-EC9CE4A26909@colorremedies.com> <519258A7.4080503@influence-pc.fr>
To: Vincent <vincent@influence-pc.fr>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


On May 14, 2013, at 9:30 AM, Vincent <vincent@influence-pc.fr> wrote:

> Why is it more easier to extend a Brfs partition rather than to reduce it, while the single raid is supposed to be made ​​for that?

Are you referring to normal operation or your degraded case? In normal operation, yes you can reduce it within the limits of the physical devices.

Expecting anything other than getting the surviving data off a -d single volume, I think, is unreasonable. If Btrfs even lets you extract the surviving data off the -d single volume, insofar as I'm aware that's better than anything else presently offers.

Chris Murphy