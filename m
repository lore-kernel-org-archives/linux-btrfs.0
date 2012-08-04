Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from csamuel.org ([74.50.50.137]:60165 "EHLO csamuel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751351Ab2HDJOs (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 4 Aug 2012 05:14:48 -0400
Message-ID: <501CE7F4.5020007@csamuel.org>
Date: Sat, 04 Aug 2012 19:14:28 +1000
From: Chris Samuel <chris@csamuel.org>
MIME-Version: 1.0
To: linux-btrfs@vger.kernel.org
CC: markmarshall8@gmail.com
Subject: Re: no space left on device
References: <CAEuwOw4sABKXS3oJpFZPq9xpbbuNxZeTRN7UUQBjcGkiHCAqeQ@mail.gmail.com>
In-Reply-To: <CAEuwOw4sABKXS3oJpFZPq9xpbbuNxZeTRN7UUQBjcGkiHCAqeQ@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Mark,

On 08/03/2012 08:05 PM, Mark Marshall wrote:

> I am new to btrfs, and just installed a new system with SLED 11 SP2 a
> few days ago.

Looking at the release notes for SLED11 SP2 it appears to ship with an 
ancient kernel (in btrfs terms), 3.0.10.  You will want to upgrade to 
*at least* a 3.2.x kernel (I use Kubuntu 12.04 on my work laptop with 
btrfs /home and had no issues with its 3.2.x), though it's likely you'll 
want to go straight to the current 3.5.x kernel.

Best of luck!
Chris
