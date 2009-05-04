From: Ric Wheeler <rwheeler@redhat.com>
Subject: Re: Data Deduplication with the help of an online filesystem check
Date: Mon, 04 May 2009 10:29:58 -0400
Message-ID: <49FEFBE6.40209@redhat.com>
References: <20090427033331.GC17677@cip.informatik.uni-erlangen.de> <1240839448.26451.13.camel@think.oraclecorp.com> <20090428155900.GA1722@cip.informatik.uni-erlangen.de> <49F728F6.6030307@wpkg.org> <20090428173251.GB7217@cip.informatik.uni-erlangen.de> <49F73FC9.3070607@partiallystapled.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Cc: Thomas Glanzmann <thomas@glanzmann.de>,
	Tomasz Chmielewski <mangoo@wpkg.org>,
	Chris Mason <chris.mason@oracle.com>,
	linux-btrfs@vger.kernel.org
To: Michael Tharp <gxti@partiallystapled.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <49F73FC9.3070607@partiallystapled.com>
List-ID: <linux-btrfs.vger.kernel.org>

On 04/28/2009 01:41 PM, Michael Tharp wrote:
> Thomas Glanzmann wrote:
>> no, I just used the md5 checksum. And even if I have a hash escalation
>> which is highly unlikely it still gives a good house number.
>
> I'd start with a crc32 and/or MD5 to find candidate blocks, then do a 
> bytewise comparison before actually merging them. Even the risk of an 
> accidental collision is too high, and considering there are plenty of 
> birthday-style MD5 attacks it would not be extraordinarily difficult 
> to construct a block that collides with e.g. a system library.
>
> Keep in mind that although digests do a fairly good job of making 
> unique identifiers for larger chunks of data, they can only hold so 
> many unique combinations. Considering you're comparing blocks of a few 
> kibibytes in size it's best to just do a foolproof comparison. There's 
> nothing wrong with using a checksum/digest as a screening mechanism 
> though.
>
> -- m. tharp

One thing in the above scheme that would be really interesting for all 
possible hash functions is maintaining good stats on hash collisions, 
effectiveness of the hash, etc. There has been a lot of press about MD5 
hash collisions for example - it would be really neat to be able to 
track real world data on those,

Ric

