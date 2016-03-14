Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ig0-f182.google.com ([209.85.213.182]:38309 "EHLO
	mail-ig0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751780AbcCNV7s (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 14 Mar 2016 17:59:48 -0400
Received: by mail-ig0-f182.google.com with SMTP id ig19so1250773igb.1
        for <linux-btrfs@vger.kernel.org>; Mon, 14 Mar 2016 14:59:48 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAPmG0jYfEnvLEHskv8uy+FjnRtv4yY8HA7bqMqZ8ScqVuAHatA@mail.gmail.com>
References: <20160227211450.GS26042@torres.zugschlus.de>
	<CAOE4rSyPvkzjKDVoQ-7U8ay5t7Pp2qeaCqh-tFg-etmgHGEOJQ@mail.gmail.com>
	<20160305143934.GE1902@torres.zugschlus.de>
	<CAJCQCtTw1+E=X1bbGgSB-fPHDtEPUO5amFUEs4fyPmTfK4QaGw@mail.gmail.com>
	<20160313115809.GQ2334@torres.zugschlus.de>
	<20160314120703.GD2334@torres.zugschlus.de>
	<CAPmG0jbwDjf6L1-9VPCwwzqj44Th9ZHaGVcY-PhoQF=eHo5hnA@mail.gmail.com>
	<20160314200546.GG2334@torres.zugschlus.de>
	<CAPmG0jYfEnvLEHskv8uy+FjnRtv4yY8HA7bqMqZ8ScqVuAHatA@mail.gmail.com>
Date: Mon, 14 Mar 2016 15:59:47 -0600
Message-ID: <CAJCQCtQHZsvQyAfWO4HGY7Jr+PGdW5L=LUTqM+5E=ys0+Ypzqw@mail.gmail.com>
Subject: Re: New file system with same issue (was: Again, no space left on
 device while rebalancing and recipe doesnt work)
From: Chris Murphy <lists@colorremedies.com>
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I'm a little mystified how btrfs check reports a problem with the
superblock, and yet this filesystem can still be mounted and used? If
it mounts rw then resize is possible but why would it be wrong in the
first place?


Chris Murphy
