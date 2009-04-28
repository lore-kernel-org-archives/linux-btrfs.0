From: Michael Tharp <gxti@partiallystapled.com>
Subject: Re: Data Deduplication with the help of an online filesystem check
Date: Tue, 28 Apr 2009 13:41:29 -0400
Message-ID: <49F73FC9.3070607@partiallystapled.com>
References: <20090427033331.GC17677@cip.informatik.uni-erlangen.de> <1240839448.26451.13.camel@think.oraclecorp.com> <20090428155900.GA1722@cip.informatik.uni-erlangen.de> <49F728F6.6030307@wpkg.org> <20090428173251.GB7217@cip.informatik.uni-erlangen.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Cc: Tomasz Chmielewski <mangoo@wpkg.org>,
	Chris Mason <chris.mason@oracle.com>,
	linux-btrfs@vger.kernel.org
To: Thomas Glanzmann <thomas@glanzmann.de>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20090428173251.GB7217@cip.informatik.uni-erlangen.de>
List-ID: <linux-btrfs.vger.kernel.org>

Thomas Glanzmann wrote:
> no, I just used the md5 checksum. And even if I have a hash escalation
> which is highly unlikely it still gives a good house number.

I'd start with a crc32 and/or MD5 to find candidate blocks, then do a 
bytewise comparison before actually merging them. Even the risk of an 
accidental collision is too high, and considering there are plenty of 
birthday-style MD5 attacks it would not be extraordinarily difficult to 
construct a block that collides with e.g. a system library.

Keep in mind that although digests do a fairly good job of making unique 
identifiers for larger chunks of data, they can only hold so many unique 
combinations. Considering you're comparing blocks of a few kibibytes in 
size it's best to just do a foolproof comparison. There's nothing wrong 
with using a checksum/digest as a screening mechanism though.

-- m. tharp
