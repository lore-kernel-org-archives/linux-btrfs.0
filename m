Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from relay3-d.mail.gandi.net ([217.70.183.195]:48426 "EHLO
	relay3-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754163Ab3BUPzW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 21 Feb 2013 10:55:22 -0500
Message-ID: <51264366.3040407@petaramesh.org>
Date: Thu, 21 Feb 2013 16:55:18 +0100
From: =?ISO-8859-1?Q?Sw=E2mi_Petaramesh?= <swami@petaramesh.org>
MIME-Version: 1.0
To: bo.li.liu@oracle.com
CC: "BTRFS, Linux" <linux-btrfs@vger.kernel.org>
Subject: Re: Another defrag question
References: <51264146.3070504@petaramesh.org> <20130221155052.GA4628@liubo.jp.oracle.com>
In-Reply-To: <20130221155052.GA4628@liubo.jp.oracle.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Le 21/02/2013 16:50, Liu Bo a écrit :
> Well, there is already a patch which addresses your concern and it's
> 'snapshot-aware defrag' feature and now in v6, it's not merged yet.
> thanks, liubo 

Hi Liu,

So should I understand that, even though the manpage states that the
issue is for kernels <= 2.6.37, I should however not defrag until the
patch you mention is actually merged in a future kernel release ?

TIA.

-- 
Swâmi Petaramesh <swami@petaramesh.org> http://petaramesh.org PGP 9076E32E
Ne cherchez pas : Je ne suis pas sur Facebook.

