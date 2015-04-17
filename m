Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.palepurple.co.uk ([89.16.183.188]:47358 "EHLO
	mail.palepurple.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932173AbbDQJ45 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 17 Apr 2015 05:56:57 -0400
Received: from localhost (localhost [127.0.0.1])
	by mail.palepurple.co.uk (Postfix) with ESMTP id E6F3D8250
	for <linux-btrfs@vger.kernel.org>; Fri, 17 Apr 2015 10:56:55 +0100 (BST)
Received: from mail.palepurple.co.uk ([127.0.0.1])
	by localhost (mail.palepurple.co.uk [127.0.0.50]) (amavisd-new, port 10024)
	with ESMTP id WyU_bPjl0zlE for <linux-btrfs@vger.kernel.org>;
	Fri, 17 Apr 2015 10:56:55 +0100 (BST)
Received: from [172.30.33.200] (host81-133-46-190.in-addr.btopenworld.com [81.133.46.190])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	(Authenticated sender: david@palepurple.co.uk)
	by mail.palepurple.co.uk (Postfix) with ESMTPSA id A5118821A
	for <linux-btrfs@vger.kernel.org>; Fri, 17 Apr 2015 10:56:55 +0100 (BST)
Message-ID: <5530D8E7.90301@codepoets.co.uk>
Date: Fri, 17 Apr 2015 10:56:55 +0100
From: David Goodwin <david@codepoets.co.uk>
MIME-Version: 1.0
To: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: Mount multiple file system with the same UUID
References: <SNT150-W75F9A63B7062DE5A608491A1E30@phx.gbl>
In-Reply-To: <SNT150-W75F9A63B7062DE5A608491A1E30@phx.gbl>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 17/04/15 10:20, WangMike wrote:
> Dear all,
>
> We know that one cannot mount multiple btrfs file systems which contain the same UUID (for example, snapshot ).
>
> Is it possible to make use of "mount namespace" achieve that? means, if the btrfs file system in different namespace can contain the same UUID.
>

I've encountered this problem using EC2 EBS volumes.

(the 'ghost image' (AMI) contains btrfs filesystems. This results in all 
child VMs having EBS volumes sharing the same UUID ... and it's then not 
being possible to move volumes around.)

I'm interested to know if there's a possible solution, aside hoping you 
can run mkfs.btrfs on first boot...

David.
