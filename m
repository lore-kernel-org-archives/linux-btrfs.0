Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from qmta03.emeryville.ca.mail.comcast.net ([76.96.30.32]:41273 "EHLO
	qmta03.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752567Ab3CSDSd convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 18 Mar 2013 23:18:33 -0400
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 6.2 \(1499\))
Subject: Re: Impossible or Possible to Securely Erase File on Btrfs?
From: Chris Murphy <lists@colorremedies.com>
In-Reply-To: <20130318191815.15073.49770@localhost.localdomain>
Date: Mon, 18 Mar 2013 21:18:28 -0600
Message-Id: <A0DACC7D-01E5-4D36-9526-E871F4E045B6@colorremedies.com>
References: <514759B5.5000507@lolwut.org> <20130318191815.15073.49770@localhost.localdomain>
To: "linux-btrfs@vger.kernel.org BTRFS" <linux-btrfs@vger.kernel.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


On Mar 18, 2013, at 1:18 PM, Chris Mason <chris.mason@fusionio.com> wrote:
> 
> We don't do this now for other reasons mentioned in the thread.  The
> best path to get here is to use trim, and to find a device that supports
> a secure erase trim (I don't know if this even exists, sorry).

I'm not finding a reference to "secure erase trim". In any case I wouldn't expect it to differ from trim. The requirement for ATA SECURITY ERASE UNIT is to replace LBA 0 to READ NATIVE MAX contents with either 0s or 1s. 

ENHANCED SECURITY ERASE UNIT additional requires data overwrite, including sectors not in use. But there's no requirement for what kind of data is used for overwriting.

Chris Murphy