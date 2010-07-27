From: Ben Chociej <bchociej@gmail.com>
Subject: Re: [RFC PATCH 0/5] Btrfs: Add hot data tracking functionality
Date: Tue, 27 Jul 2010 18:18:23 -0500
Message-ID: <AANLkTi=x9q1XOu_6F2hOv_ZPoM+McKz9Nv2Q5GZNfa4a@mail.gmail.com>
References: <1280268023-18408-1-git-send-email-bchociej@gmail.com>
	<201007280110.46059.diegocg@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: chris.mason@oracle.com, linux-btrfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, cmm@us.ibm.com, bcchocie@us.ibm.com,
	mrlupfer@us.ibm.com, crscott@us.ibm.com,
	linux-kernel@vger.kernel.org
To: diegocg@gmail.com
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <201007280110.46059.diegocg@gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Jul 27, 2010 at 6:10 PM, Diego Calleja <diegocg@gmail.com> wrot=
e:
> On Mi=E9rcoles, 28 de Julio de 2010 00:00:18 bchociej@gmail.com escri=
bi=F3:
>> With Btrfs's COW approach, an external cache (where data is moved to
>> SSD, rather than just cached there) makes a lot of sense. Though the=
se
>
> As I understand it, what your proyect intends to do is to move "hot"
> data to a SSD which would be part of a Btrfs pool, and not do any
> kind of SSD caching, as bcache (http://lwn.net/Articles/394672/) does=
?
>

Yes, that's correct. It's likely not going to be a cache in the
traditional sense, since the entire capacity of both HDD and SSD would
be available.

BC
