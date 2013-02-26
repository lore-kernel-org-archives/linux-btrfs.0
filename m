Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from ipmail05.adl6.internode.on.net ([150.101.137.143]:24141 "EHLO
	ipmail05.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756077Ab3BZHIU (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 26 Feb 2013 02:08:20 -0500
Date: Tue, 26 Feb 2013 18:08:17 +1100
From: Dave Chinner <david@fromorbit.com>
To: Remco Hosman - Yerf IT <remco@yerf-it.nl>
Cc: Suman C <schakrava@gmail.com>, linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: lvm volume like support
Message-ID: <20130226070817.GQ5551@dastard>
References: <CAPF83msjTJWjWJgJOAWsQ2GoxAC-cZ4GkK_+H11tAyA689KD_w@mail.gmail.com>
 <CAMU1PDhQqm6s5FUbVJa5nwOD4Ewf-6Cr2gx2khHHwrBxUqsQDA@mail.gmail.com>
 <CAG1y0scOg2QGCZdCTkKHBn5xxNh5GGmdXTcS8rOesup4r1JsXQ@mail.gmail.com>
 <CAPF83mvfLrDvBvbP5Oe_R94BM7Lr5pZD=gpnDrr4TquBq88q5Q@mail.gmail.com>
 <20130226115704.50102196@natsu>
 <CAPF83mv2qVqE5HnXVr9P8JHqs4+DKjt0hWaR8UG6Kk4reyPsAw@mail.gmail.com>
 <FEF2721D-ABA2-4CE7-A562-6210B0946BF8@yerf-it.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <FEF2721D-ABA2-4CE7-A562-6210B0946BF8@yerf-it.nl>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Feb 26, 2013 at 07:28:43AM +0100, Remco Hosman - Yerf IT wrote:
> would be really cool if a TRIM to the loopback device would do a
> 'hole punch' on the file

dfaa2ef loop: add discard support for loop devices

-- 
Dave Chinner
david@fromorbit.com
