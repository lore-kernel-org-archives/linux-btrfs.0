Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:53606 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751801Ab3CJXmO (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 10 Mar 2013 19:42:14 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1UEprS-0001HL-EG
	for linux-btrfs@vger.kernel.org; Mon, 11 Mar 2013 00:41:02 +0100
Received: from cpc2-with5-2-0-cust470.1-4.cable.virginmedia.com ([81.97.59.215])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Mon, 11 Mar 2013 00:41:02 +0100
Received: from samtygier by cpc2-with5-2-0-cust470.1-4.cable.virginmedia.com with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Mon, 11 Mar 2013 00:41:02 +0100
To: linux-btrfs@vger.kernel.org
From: sam tygier <samtygier@yahoo.co.uk>
Subject: Re: [PATCH 0/5] [RFC] RAID-level terminology change
Date: Sun, 10 Mar 2013 23:40:27 +0000
Message-ID: <khj5l7$ge9$1@ger.gmane.org>
References: <1362861071-12589-1-git-send-email-hugo@carfax.org.uk> <513CAA25.2010803@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
In-Reply-To: <513CAA25.2010803@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 10/03/13 15:43, Goffredo Baroncelli wrote:
> - DUP			-> dD		(to allow more that 2 copy per
> 					 disk)
> 
> - RAID1			-> nC or *C	
> 
> - RAID0 		-> mS or *S
> 
> - RAID10		-> nCmS or *CmS or nC*s
> 
> - RAID with parity	-> mSpP or *SpP or mS*p (it is possible ?)
> 
> - single		-> 1C or 1D or 1S or "single"
> 
> 
> where d,n,m,p are integers; '*' is the literal '*' and means "how many
> possible".

Using an asterisk '*' in something will be used as a command line argument risks having the shell expand it. Sticking to pure alphanumeric names would be better.

