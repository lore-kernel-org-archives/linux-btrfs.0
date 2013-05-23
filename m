Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from srv2.trombetti.net ([65.254.53.252]:2740 "EHLO
	srv2.trombetti.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758671Ab3EWNsW (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 23 May 2013 09:48:22 -0400
Message-ID: <519E1C95.4030501@shiftmail.org>
Date: Thu, 23 May 2013 15:41:41 +0200
From: Bob Marley <bobmarley@shiftmail.org>
MIME-Version: 1.0
To: Bernd Schubert <bernd.schubert@itwm.fraunhofer.de>
CC: Chris Mason <chris.mason@fusionio.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: raid6: rmw writes all the time?
References: <knl3ke$n7t$1@ger.gmane.org> <20130523131118.4907.45217@localhost.localdomain> <519E1821.5070507@itwm.fraunhofer.de>
In-Reply-To: <519E1821.5070507@itwm.fraunhofer.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 23/05/2013 15:22, Bernd Schubert wrote:
>
> Yeah, I know and I'm using iostat already. md raid6 does not do rmw, 
> but does not fill the device queue, afaik it flushes the underlying 
> devices quickly as it does not have barrier support - that is another 
> topic, but was the reason why I started to test btrfs.

MD raid6 DOES have barrier support!

