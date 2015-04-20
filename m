Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail1207.opentransfer.com ([98.130.1.227]:42747 "EHLO
	mail1207.opentransfer.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753266AbbDTO3a (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 20 Apr 2015 10:29:30 -0400
Message-ID: <55350D48.2020404@friendlyvirus.org>
Date: Mon, 20 Apr 2015 15:29:28 +0100
From: =?windows-1252?Q?Miguel_Negr=E3o?=
	<miguel.negrao-lists@friendlyvirus.org>
MIME-Version: 1.0
To: sander@humilis.net
CC: linux-btrfs@vger.kernel.org
Subject: Re: corruption in USB harddrive - backup via send/receive - question
References: <loom.20150416T202016-456@post.gmane.org> <20150420140748.GA26890@panda>
In-Reply-To: <20150420140748.GA26890@panda>
Content-Type: text/plain; charset=windows-1252
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 20-04-2015 15:07, Sander wrote:
> Miguel Negrão wrote (ao):
>>  - Given that I'm running a laptop and comunicating with the harddrives via
>> USB, is it expected that I will get some corruption from time to time or is
>> this abnormal
> 
> Abnormal. I have three Intel ssd's usb connected to an Arndale. Two of
> them have luks and btrfs raid0 on top, and is used as a home server. The
> third ssd is plain btrfs, and used for backup archives.

Hi Sander.

Good to know. Indeed I think something's wrong with the enclosure, I
keep getting some minimal corruption from time to time. I also use btrfs
over luks.

 I'm considering buying a thunderbolt (I have a macbook pro) to esata
converter, as bypassing the usb interface might be more stable. I
imagine esata is better for btrfs then usb, correct ? Anyone here has
experience with thunderbolt in linux ? My understanding it that if
connected at boot time, devices should just appear as normal pci devices.

Best,
Miguel
