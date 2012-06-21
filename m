Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtp205.alice.it ([82.57.200.101]:37507 "EHLO smtp205.alice.it"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759912Ab2FURF6 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 21 Jun 2012 13:05:58 -0400
Message-ID: <4FE35473.4050005@libero.it>
Date: Thu, 21 Jun 2012 19:05:55 +0200
From: Goffredo Baroncelli <kreijack@libero.it>
Reply-To: kreijack@inwind.it
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>
CC: kreijack@inwind.it, cwillu <cwillu@cwillu.com>, helmut@hullen.de,
        linux-btrfs@vger.kernel.org
Subject: Re: R: Re: Subvolumes and /proc/self/mountinfo
References: <32353828.234981340193742067.JavaMail.defaultUser@defaultHost> <4FE1EE52.20002@zytor.com> <4FE1FB9B.1090203@libero.it> <4FE20B3D.5060704@zytor.com> <4FE21134.9090501@libero.it> <4FE2455E.2090007@zytor.com> <4FE2B576.3030301@libero.it> <4FE323DB.1070507@zytor.com>
In-Reply-To: <4FE323DB.1070507@zytor.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 06/21/2012 03:38 PM, H. Peter Anvin wrote:
>> But if /boot has to be in a separate filesystem, which is the point to
>> > support btrfs at all ? Does make sense to support only a subset of btrfs
>> > features ?
>> > 
> Yes, and that's another good reason for /boot: btrfs supports that kind
> of policy (e.g. "no compression or encryption in this subtree.")

But what about large disk ? Syslinux is able to handle large disk ? Or
it uses BIOS interrupt?

