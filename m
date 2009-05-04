From: Thomas Glanzmann <thomas@glanzmann.de>
Subject: Re: Data Deduplication with the help of an online filesystem check
Date: Mon, 4 May 2009 17:15:18 +0200
Message-ID: <20090504151518.GA13777@cip.informatik.uni-erlangen.de>
References: <20090427033331.GC17677@cip.informatik.uni-erlangen.de> <1240839448.26451.13.camel@think.oraclecorp.com> <20090428155900.GA1722@cip.informatik.uni-erlangen.de> <49F728F6.6030307@wpkg.org> <20090428173251.GB7217@cip.informatik.uni-erlangen.de> <49F73FC9.3070607@partiallystapled.com> <49FEFBE6.40209@redhat.com> <49FEFE27.5090804@wpkg.org> <49FEFF9A.8060803@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Tomasz Chmielewski <mangoo@wpkg.org>,
	Michael Tharp <gxti@partiallystapled.com>,
	Chris Mason <chris.mason@oracle.com>,
	linux-btrfs@vger.kernel.org
To: Ric Wheeler <rwheeler@redhat.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <49FEFF9A.8060803@redhat.com>
List-ID: <linux-btrfs.vger.kernel.org>

Hello Ric,

> (1) Block level or file level dedup?

what is the difference between the two?

> (2) Inband dedup (during a write) or background dedup?

I think inband dedup is way to intensive on ressources (memory) and also
would kill every performance benchmark. So I think the offline dedup is
the right way to go.

> (3) How reliably can you protect the pool of blocks? How reliably can
> you protect the database that maps hashes to blocks?

You have to lock down the i/o requests for the blocks in question and
compare them byte by byte anyway, just to make sure.

> (4) Can you give users who are somewhat jaded confidence in your
> solution (this is where stats come in very handy!)

For virtual machines you can reduce the used data by 1/3. Of course it
can blow in your face when you don't watch your physical resources
closely.

        Thomas
