Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:58458 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752716AbaLAJfF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 1 Dec 2014 04:35:05 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1XvNNn-0003D0-Bj
	for linux-btrfs@vger.kernel.org; Mon, 01 Dec 2014 10:35:03 +0100
Received: from 94.250.180.197 ([94.250.180.197])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Mon, 01 Dec 2014 10:35:03 +0100
Received: from gour by 94.250.180.197 with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Mon, 01 Dec 2014 10:35:03 +0100
To: linux-btrfs@vger.kernel.org
From: Gour <gour@atmarama.net>
Subject: Re: pro/cons of raid1 with mdadm/lvm2
Date: Mon, 1 Dec 2014 10:30:27 +0100
Message-ID: <20141201103027.5d107aef@atmarama>
References: <20141130121147.45884217@atmarama>
	<E4D50A09-CBA8-47DB-833B-D80D7BD6BD92@coker.com.au>
	<CAJCQCtTM8JpH_-E6dsbV53aCx7V9ptH94peST63KJ6AR=OCDqQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, 30 Nov 2014 18:00:37 -0700
Chris Murphy <lists@colorremedies.com> wrote:

> Yeah. I'm not sure though if openSUSE 13.2 prevents users from
> creating btrfs raid1 volumes entirely, or if it's just an install time
> limitation.

I was able to create btrfs raid1 volumes under lvm, but installer failed
at installing Grub2.

Don't know if it is installer limitation and decided to use btrfs'
native raid1, at least for root. Will see whether to use it for /home as
well or use XFS as suggested by SUSE.


Sincerely,
Gour

-- 
In the material world, one who is unaffected by whatever good 
or evil he may obtain, neither praising it nor despising it, 
is firmly fixed in perfect knowledge.

-- 
The humble sages, by virtue of true knowledge, see with equal 
vision a learned and gentle brāhmana, a cow, an elephant, a dog 
and a dog-eater.

http://www.atmarama.net | Hlapicina (Croatia) | GPG: 52B5C810


