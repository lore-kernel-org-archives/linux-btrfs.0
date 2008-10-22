From: Avi Kivity <avi@redhat.com>
Subject: Re: Some very basic questions
Date: Wed, 22 Oct 2008 20:28:26 +0200
Message-ID: <48FF70CA.9090604@redhat.com>
References: <20081021132322.271ad728.skraw@ithnet.com>	 <48FDD710.5050702@hp.com> <20081021190136.89b2c6af.skraw@ithnet.com>	 <20081021171513.GA8799@infradead.org> <48FE11F9.7040700@gmail.com>	 <20081022142759.ac33a16c.skraw@ithnet.com>	 <1224681345.6448.4.camel@think.oraclecorp.com> <48FF2A5B.80108@redhat.com>	 <48FF396B.1020700@redhat.com> <48FF3CB9.6070404@redhat.com>	 <48FF3EB8.6050306@redhat.com> <48FF4082.407@redhat.com>	 <48FF4302.5030204@redhat.com>  <48FF45EE.7010001@redhat.com> <1224689639.6448.72.camel@think.oraclecorp.com> <48FF4A17.80204@redhat.com> <48FF4CAE.3080206@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Cc: Chris Mason <chris.mason@oracle.com>,
	Stephan von Krawczynski <skraw@ithnet.com>,
	Christoph Hellwig <hch@infradead.org>,
	jim owens <jowens@hp.com>, linux-btrfs@vger.kernel.org
To: Ric Wheeler <rwheeler@redhat.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <48FF4CAE.3080206@redhat.com>
List-ID: <linux-btrfs.vger.kernel.org>

Ric Wheeler wrote:
> For any given set of disks, you "just" need to do the math to compute 
> the utilized capacity, the expected rate of drive failure, the rebuild 
> time and then see whether you can recover from your first failure 
> before a 2nd disk dies.
>

Spare disks have the advantage of a fully linear access pattern 
(ignoring normal working load).  Spare capacity has the advantage of 
utilizing all devices (if you have a hundred-disk fs, all surviving 
disks participate in the rebuild; whereas with spare disks you are 
limited to the surviving raidset members.

Spare capacity also has the advantage that you don't need to rebuild 
free space.
> In practice, this is not an academic question since drives do 
> occasionally fail in batches (and drives from the same batch get 
> stuffed into the same system).

This seems to be orthogonal to the sparing method used; and in both 
cases the answer is to tolerate dual failures.  File-based redundancy 
has the advantage here of allowing triple mirroring for metadata and 
frequently written files, and double parity raid for large files.

> I suspect that what will be used in mission critical deployments will 
> be more conservative than what is used in less critical path systems

That's true, unfortunately.  But with time people will trust the newer, 
more efficient methods.

-- 
I have a truly marvellous patch that fixes the bug which this
signature is too narrow to contain.

