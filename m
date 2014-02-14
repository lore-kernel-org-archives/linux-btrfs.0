Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from outrelay06.libero.it ([212.52.84.110]:45630 "EHLO
	outrelay06.libero.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752532AbaBNR46 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 14 Feb 2014 12:56:58 -0500
Message-ID: <52FE58EF.1060901@libero.it>
Date: Fri, 14 Feb 2014 18:57:03 +0100
From: Goffredo Baroncelli <kreijack@libero.it>
Reply-To: kreijack@inwind.it
MIME-Version: 1.0
To: Roman Mamedov <rm@romanrm.net>, kreijack@inwind.it
CC: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 5/8] Add command btrfs filesystem disk-usage
In-Reply-To: <20140214030045.415e21da@natsu>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>
References: <52FD1AD6.50500@libero.it>
 <20140214012810.26297146@natsu>
 <52FD21B4.4050502@libero.it>
 <20140214030045.415e21da@natsu>

On 02/13/2014 10:00 PM, Roman Mamedov wrote:
> On Thu, 13 Feb 2014 20:49:08 +0100
> Goffredo Baroncelli <kreijack@libero.it> wrote:
> 
>> Thanks for the comments, however I don't like du not usage; but you are right 
>> when you don't like "disk-usage". What about "btrfs filesystem chunk-usage" ?
> 
> Personally I don't see the point of being super-pedantic here, i.e. "look this
> is not just filesystem usage, this is filesystem CHUNK usage"... Consistency
> of having a matching "dev usage" and "fi usage" would have been nicer.


What about "btrfs filesystem chunk-usage" ? 

-- 
gpg @keyserver.linux.it: Goffredo Baroncelli (kreijackATinwind.it>
Key fingerprint BBF5 1610 0B64 DAC6 5F7D  17B2 0EDA 9B37 8B82 E0B5
