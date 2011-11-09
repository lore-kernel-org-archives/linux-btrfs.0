From: Jan Schmidt <list.btrfs@jan-o-sch.net>
Subject: Re: [GIT PULL] Btrfs pull request
Date: Wed, 09 Nov 2011 11:49:38 +0100
Message-ID: <4EBA5AC2.70403@jan-o-sch.net>
References: <20111106183851.GA4339@shiny> <CAK-xaQau04whLQm0Fz-fkCZ1AumLs84UiqGi0Rc=GZUzRvV7Gg@mail.gmail.com> <4EB7A6CC.5030502@gmx.net> <CAK-xaQbvpZQzPVxunSEVDzTXXzQ2HaQWHVR3BwR1iq95URWEdw@mail.gmail.com> <4EB7D2D8.2060505@gmx.net> <CAK-xaQbmY2Z3OJyQ211cUQn0CM2ho2U+UgpRKK9bUzxhEu6hzQ@mail.gmail.com> <4EB8DEAC.7000906@gmx.net> <20111109010701.GI4149@shiny> <20111109074847.GA16742@infradead.org> <4EBA560B.1070509@jan-o-sch.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Cc: Christoph Hellwig <hch@infradead.org>,
	Chris Mason <chris.mason@oracle.com>,
	Arne Jansen <sensille@gmx.net>,
	Andrea Gelmini <andrea.gelmini@gmail.com>,
	LKML <linux-kernel@vger.kernel.org>
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <4EBA560B.1070509@jan-o-sch.net>
List-ID: <linux-btrfs.vger.kernel.org>

On 09.11.2011 11:29, Jan Schmidt wrote:
> "grep bio_add_page fs/btrfs/*.c" will make you unhappy.

Phew. Actually, not that unhappy. Many of the lines seeming to have no 
return value check are in fact part of a long or-ed if-statement. Seems 
okay after a closer look.

-Jan
