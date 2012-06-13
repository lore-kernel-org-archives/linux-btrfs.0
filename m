Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from csamuel.org ([74.50.50.137]:43910 "EHLO csamuel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750880Ab2FMFEY (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 13 Jun 2012 01:04:24 -0400
Message-ID: <4FD81F46.3010702@csamuel.org>
Date: Wed, 13 Jun 2012 15:04:06 +1000
From: Chris Samuel <chris@csamuel.org>
MIME-Version: 1.0
To: Alexandre Oliva <oliva@lsd.ic.unicamp.br>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Josef Bacik <josef@redhat.com>, Chris Mason <chris.mason@oracle.com>,
        stable@vger.kernel.org, linux-btrfs@vger.kernel.org,
        ceph-devel@vger.kernel.org
Subject: Re: ceph-on-btrfs inline-cow regression fix for 3.4.3
References: <orvcivvppp.fsf@livre.localdomain>
In-Reply-To: <orvcivvppp.fsf@livre.localdomain>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 13/06/12 13:46, Alexandre Oliva wrote:

> I know btrfs hasn't had maintenance fixes in stable series, but Chris
> Mason tells me the only reason is that nobody stepped up to do so.
> Given my interest, I might as well give it a try ;-)

Actually 3.3.3 had a fix for btrfs in it.. :-)

http://lwn.net/Articles/493971/

cheers,
Chris
-- 
 Chris Samuel  :  http://www.csamuel.org/  :  Melbourne, VIC
