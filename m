From: Paul Millar <paul.millar@desy.de>
Subject: Re: A couple of questions
Date: Mon, 31 May 2010 19:59:46 +0200
Message-ID: <201005311959.47212.paul.millar@desy.de>
References: <201005271539.55644.paul.millar@desy.de> <201005271656.00398.hka@qbs.com.pl>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Cc: linux-btrfs@vger.kernel.org
To: Hubert Kario <hka@qbs.com.pl>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <201005271656.00398.hka@qbs.com.pl>
List-ID: <linux-btrfs.vger.kernel.org>

Hi Hubert,

On Thursday 27 May 2010 16:56:00 Hubert Kario wrote:
> > Would [obtaining file checksum] be possible (without an awful lot
> > of work)?
> 
> [Calculating checksum in-memory]  won't detect in-memory corruption
> though, but if you want to be resilant to this, you should be looking at
>  ECC RAM as subsequent checks can be affected by it to.

Certainly ECC RAM will help, but unfortunately it doesn't remove the 
possibility of corruption; for example, CERN found [1] that double-bit memory 
corruptions (which ECC cannot recover from) can still happen.

[1] 
http://indico.cern.ch/getFile.py/access?contribId=3&sessionId=0&resId=1&materialId=paper&confId=13797

Also, IIRC there was a case where Fermilab tracked down a data corruption to a 
faulty PCI bus in the server.  So who knows where are all the places 
corruption could occur?

I guess the real problem is that, when processing large amounts of data, these 
rare occurrences start to stack up.


> Second, you shouldn't tie application or network protocol to a CRC scheme
>  used by filesystem on server! Especially when there can be other CRC
>  algorithms used, not only CRC-32C.

Sure, but the protocol isn't tied to any particular checksum algorithm.

 
> If the checksum algorithm used by FS was set in stone, then userspace could
> employ it somehow, but if there can be different CRCs used, I see no reason
>  to allow the userspace to read them.

I agree that a checksum value, without knowing the algorithm, isn't much use.  
However, the FS reported a string representation of the tuple (algorithm, 
value); for example:

   0:DCD05C54

(where "0" is from BTRFS_CSUM_TYPE_CRC32)

Would that allow meaningful use of this information?

Cheers,

Paul.
