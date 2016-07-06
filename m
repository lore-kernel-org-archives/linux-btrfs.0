Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from zimbra.cs.ucla.edu ([131.179.128.68]:48095 "EHLO
	zimbra.cs.ucla.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753130AbcGFPLw (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 6 Jul 2016 11:11:52 -0400
Subject: Re: [Bug-tar] stat() on btrfs reports the st_blocks with delay (data
 loss in archivers)
To: Joerg Schilling <Joerg.Schilling@fokus.fraunhofer.de>, antonio@gnu.org
References: <2628320.PvJcFm1FZr@unused-4-107.brq.redhat.com>
 <A865BDE1-B7F5-4D3B-9C0C-96E5A55B5410@dilger.ca>
 <577b7dd1.tgcc3Oz1nmHZ676h%Joerg.Schilling@fokus.fraunhofer.de>
 <78b3f192-ec4b-6da2-91b4-7369c5eceadc@gmail.com>
 <577cf051.4qpBvyW8ljjUEUZn%Joerg.Schilling@fokus.fraunhofer.de>
 <577D191F.90709@gnu.org>
 <577d1b65.pxyPJIXK4jVojlar%Joerg.Schilling@fokus.fraunhofer.de>
 <577D1D38.2090801@cs.ucla.edu>
 <577d1f11.ECLAA6oU6lhcCjFc%Joerg.Schilling@fokus.fraunhofer.de>
Cc: linux-btrfs@vger.kernel.org, bug-tar@gnu.org, ahferroin7@gmail.com,
        adilger@dilger.ca
From: Paul Eggert <eggert@cs.ucla.edu>
Message-ID: <577D1FB3.3030708@cs.ucla.edu>
Date: Wed, 6 Jul 2016 17:11:47 +0200
MIME-Version: 1.0
In-Reply-To: <577d1f11.ECLAA6oU6lhcCjFc%Joerg.Schilling@fokus.fraunhofer.de>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 07/06/2016 05:09 PM, Joerg Schilling wrote:
> you concur that a delayed assignment of the "correct" value for
> st_blocks while the contend of the file does not change is not permitted.
I'm not sure I agree even with that. A file system may undergo garbage 
collection and compaction, for instance, in which a file's data do not 
change but its internal representation does.
