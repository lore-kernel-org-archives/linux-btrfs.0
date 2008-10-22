From: Avi Kivity <avi@redhat.com>
Subject: Re: Some very basic questions
Date: Wed, 22 Oct 2008 17:39:04 +0200
Message-ID: <48FF4918.6070600@redhat.com>
References: <20081021132322.271ad728.skraw@ithnet.com>	 <48FDD710.5050702@hp.com> <20081021190136.89b2c6af.skraw@ithnet.com>	 <20081021171513.GA8799@infradead.org> <48FE11F9.7040700@gmail.com>	 <20081022142759.ac33a16c.skraw@ithnet.com> <1224681345.6448.4.camel@think.oraclecorp.com> <48FF2A5B.80108@redhat.com> <48FF396B.1020700@redhat.com> <48FF3CB9.6070404@redhat.com> <48FF3EB8.6050306@redhat.com> <48FF4082.407@redhat.com> <48FF4302.5030204@redhat.com> <48FF45EE.7010001@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Cc: Chris Mason <chris.mason@oracle.com>,
	Stephan von Krawczynski <skraw@ithnet.com>,
	Christoph Hellwig <hch@infradead.org>,
	jim owens <jowens@hp.com>, linux-btrfs@vger.kernel.org
To: Ric Wheeler <rwheeler@redhat.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <48FF45EE.7010001@redhat.com>
List-ID: <linux-btrfs.vger.kernel.org>

Ric Wheeler wrote:
> I think that the btrfs plan is still to push more complicated RAID 
> schemes off to MD (RAID6, etc) so this is an issue even with a JBOD. 
> It will be interesting to map out the possible ways to use built in 
> mirroring, etc vs the external RAID and actually measure the utilized 
> capacity and performance (online & during rebuilds).

That's leaving a lot of performance and features on the table, IMO.  We 
definitely want to have metadata and small files using mirroring 
(perhaps even three copies for some metadata).  Use RAID[56] for large 
files.  Perhaps even start files at RAID1, and have the scrubber convert 
them to RAID[56] when it notices they are only ever read.  Keep 
temporary or unimportant files at RAID0.  Play games with asymmetric 
setups (small fast disks + large slow disks). etc etc etc.

Delegating things to MD throws out a lot of metadata so these things 
become impossible.

-- 
error compiling committee.c: too many arguments to function

