Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from dkim1.fusionio.com ([66.114.96.53]:37204 "EHLO
	dkim1.fusionio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752366Ab3CGPfK (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Thu, 7 Mar 2013 10:35:10 -0500
Received: from mx2.fusionio.com (unknown [10.101.1.160])
	by dkim1.fusionio.com (Postfix) with ESMTP id 965267C0435
	for <linux-btrfs@vger.kernel.org>; Thu,  7 Mar 2013 08:35:09 -0700 (MST)
Date: Thu, 7 Mar 2013 10:35:07 -0500
From: Chris Mason <chris.mason@fusionio.com>
To: =?iso-8859-1?Q?Sw=E2mi?= Petaramesh <swami@petaramesh.org>
CC: Eric Sandeen <sandeen@redhat.com>,
        "BTRFS, Linux" <linux-btrfs@vger.kernel.org>,
        "Anand.Jain@oracle.com" <Anand.Jain@oracle.com>
Subject: Re: mkfs.btrfs broken
Message-ID: <20130307153507.GA5784@shiny.masoncoding.com>
References: <513883DD.8080203@petaramesh.org>
 <5138980C.8080000@redhat.com>
 <5138ADA6.5070101@petaramesh.org>
 <5138AE96.3020304@redhat.com>
 <5138B08F.70607@petaramesh.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
In-Reply-To: <5138B08F.70607@petaramesh.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Mar 07, 2013 at 08:21:51AM -0700, Swâmi Petaramesh wrote:
> Le 07/03/2013 16:13, Eric Sandeen a écrit :
> > # strace -o tracefile.txt mkfs.btrfs /dev/sda5 tracefile.txt will
> > contain all syscalls made by the binary and their results, which might
> > give us a clue what's gone wrong. -Eric
> 
> Here it goes !

Could you please send the contents of /proc/mounts

-chris
