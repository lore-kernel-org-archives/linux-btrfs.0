From: Jan Schmidt <list.btrfs@jan-o-sch.net>
Subject: Re: [GIT PULL] Btrfs pull request
Date: Wed, 09 Nov 2011 11:29:31 +0100
Message-ID: <4EBA560B.1070509@jan-o-sch.net>
References: <20111106183851.GA4339@shiny> <CAK-xaQau04whLQm0Fz-fkCZ1AumLs84UiqGi0Rc=GZUzRvV7Gg@mail.gmail.com> <4EB7A6CC.5030502@gmx.net> <CAK-xaQbvpZQzPVxunSEVDzTXXzQ2HaQWHVR3BwR1iq95URWEdw@mail.gmail.com> <4EB7D2D8.2060505@gmx.net> <CAK-xaQbmY2Z3OJyQ211cUQn0CM2ho2U+UgpRKK9bUzxhEu6hzQ@mail.gmail.com> <4EB8DEAC.7000906@gmx.net> <20111109010701.GI4149@shiny> <20111109074847.GA16742@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Cc: Christoph Hellwig <hch@infradead.org>,
	Chris Mason <chris.mason@oracle.com>,
	Arne Jansen <sensille@gmx.net>,
	Andrea Gelmini <andrea.gelmini@gmail.com>,
	LKML <linux-kernel@vger.kernel.org>
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20111109074847.GA16742@infradead.org>
List-ID: <linux-btrfs.vger.kernel.org>

Am 09.11.2011 08:48, schrieb Christoph Hellwig:
> On Tue, Nov 08, 2011 at 08:07:01PM -0500, Chris Mason wrote:
>> Looks like bio_add_page() is failing and we're getting the enomem from
>> there.  LVM is only letting us put one page in each bio.
>
> Yes, at the moment all bio based DM targets only allow single page I/O.

Wait. If I got that correctly, each bio_add_page needs special ENOMEM 
treatment (assuming the target could always be a device mapper target), 
right?

"grep bio_add_page fs/btrfs/*.c" will make you unhappy.

-Jan
