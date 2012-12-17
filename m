Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from 220-245-31-42.static.tpgi.com.au ([220.245.31.42]:58023 "EHLO
	smtp.sws.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751536Ab2LQLUu (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 17 Dec 2012 06:20:50 -0500
From: Russell Coker <russell@coker.com.au>
Reply-To: russell@coker.com.au
To: sander@humilis.net
Subject: Re: btrfs subvolume snapshot performance problem
Date: Mon, 17 Dec 2012 22:20:42 +1100
Cc: Sylvain Alain <d2racing911@gmail.com>, linux-btrfs@vger.kernel.org
References: <CACR_K2uer3bniWAenoKe=-2BxT4vt4opXywCBbwGuaX7C8EgLA@mail.gmail.com> <20121217103624.GA15304@panda>
In-Reply-To: <20121217103624.GA15304@panda>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <201212172220.42946.russell@coker.com.au>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, 17 Dec 2012, Sander <sander@humilis.net> wrote:
> Let me repeat the answer cwillu gave to Russell on this, and Russell's
> response:

Also tests did indicate a performance benefit on snapshots when I stopped using 
discard.  It was as much as 15 seconds to create a snapshot and now it's 
consistently less than 1 second.

-- 
My Main Blog         http://etbe.coker.com.au/
My Documents Blog    http://doc.coker.com.au/
