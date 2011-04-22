From: Sunil Mushran <sunil.mushran@oracle.com>
Subject: Re: [PATCH 1/2] fs: add SEEK_HOLE and SEEK_DATA flags
Date: Fri, 22 Apr 2011 09:57:32 -0700
Message-ID: <4DB1B37C.9070406@oracle.com>
References: <1303414954-3315-1-git-send-email-josef@redhat.com> <loom.20110422T001650-760@post.gmane.org> <BANLkTiknb+hzFAjpwESwMcqMVtkFc0HFQQ@mail.gmail.com> <20110422045054.GB17795@infradead.org> <20110422112852.GB1627@x4.trippels.de> <4DB16B72.1050702@redhat.com> <4DB1AC9D.3010706@oracle.com> <4DB1AF6F.4040706@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Cc: Markus Trippelsdorf <markus@trippelsdorf.de>,
	Christoph Hellwig <hch@infradead.org>,
	Josef Bacik <josef@toxicpanda.com>,
	linux-kernel@vger.kernel.org, linux-btrfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org
To: Eric Blake <eblake@redhat.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <4DB1AF6F.4040706@redhat.com>
List-ID: <linux-btrfs.vger.kernel.org>

On 04/22/2011 09:40 AM, Eric Blake wrote:
> On 04/22/2011 10:28 AM, Sunil Mushran wrote:
>> while(1) {
>>      read(block);
>>      if (block_all_zeroes)
>>          lseek(SEEK_DATA);
>> }
>>
>> What's wrong with the above? If this is the case, even SEEK_HOLE
>> is not needed but should be added as it is already in Solaris.
> Because you don't know if the block is the same size as the minimum
> hole, and because some systems require rather large holes (my Solaris
> testing on a zfs system didn't have holes until 128k), that's a rather
> large amount of reading just to prove that the block has all zeros to
> know that it is even worth trying the lseek(SEEK_DATA).  My gut feel is
> that doing the lseek(SEEK_HOLE) up front coupled with seeking back to
> the same position is more efficient than manually checking for a run of
> zeros (less cache pollution, works with 4k read buffers without having
> to know filesystem hole size).

Holes are an implementation detail.

cp can read whatever blocksize it chooses. If that block contains
zero, it would signal cp that maybe it should SEEK_DATA and skip
reading all those blocks. That's all. We are not trying to achieve
perfection. We are just trying to reduce cpu waste.

If the fs supports SEEK_*, then great. If it does not, then it is no
worse than before.
