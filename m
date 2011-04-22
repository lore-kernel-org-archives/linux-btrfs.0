From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: [PATCH 1/2] fs: add SEEK_HOLE and SEEK_DATA flags
Date: Fri, 22 Apr 2011 12:06:13 -0600
Message-ID: <B7EE7E9A-083C-4914-8A69-4DD3448D06B3@dilger.ca>
References: <1303414954-3315-1-git-send-email-josef@redhat.com> <loom.20110422T001650-760@post.gmane.org> <BANLkTiknb+hzFAjpwESwMcqMVtkFc0HFQQ@mail.gmail.com> <20110422045054.GB17795@infradead.org> <20110422112852.GB1627@x4.trippels.de> <4DB16B72.1050702@redhat.com> <4DB1AC9D.3010706@oracle.com> <4DB1AF6F.4040706@redhat.com> <4DB1B37C.9070406@oracle.com> <4DB1B4F1.8070109@redhat.com> <4DB1B62B.3000700@oracle.com>
Mime-Version: 1.0 (iPhone Mail 8H7)
Content-Type: text/plain;
	charset=us-ascii
Cc: Eric Blake <eblake@redhat.com>,
	Markus Trippelsdorf <markus@trippelsdorf.de>,
	Christoph Hellwig <hch@infradead.org>,
	Josef Bacik <josef@toxicpanda.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
	"linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>
To: Sunil Mushran <sunil.mushran@oracle.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <4DB1B62B.3000700@oracle.com>
List-ID: <linux-btrfs.vger.kernel.org>

On 2011-04-22, at 11:08 AM, Sunil Mushran <sunil.mushran@oracle.com> wrote:
> On 04/22/2011 10:03 AM, Eric Blake wrote:
>>> cp can read whatever blocksize it chooses. If that block contains
>>> zero, it would signal cp that maybe it should SEEK_DATA and skip
>>> reading all those blocks. That's all. We are not trying to achieve
>>> perfection. We are just trying to reduce cpu waste.
>>> 
>>> If the fs supports SEEK_*, then great. If it does not, then it is no
>>> worse than before.
>> But providing just SEEK_DATA _is_ worse than before if you don't provide
>> the correct SEEK_HOLE everywhere.  Because then your algorithm of trying
>> lseek(SEEK_DATA) after every run of zeros in the hopes of an
>> optimization is a wasted syscall, since it will just return your current
>> offset every time, so you end up with more syscalls than if you had used
>> the single lseek(SEEK_DATA) that returns the end of the file up front,
>> and known that the remainder of the file has no holes to even try
>> seeking past.
> 
> You are over-optimizing. strace any process on your box and you
> will find numerous wasted syscalls.

Sure, there are lots of wasted syscalls, but in this case the cost of doing extra SEEK_DATA and SEEK_HOLE operations may be fairly costly. This involves scanning the whole disk layout, possibly over a network, which might need tens or hundreds of disk seeks to read the metadata, unlike regular SEEK_SET.

Even SEEK_END is somewhat costly on a network filesystem, since the syscall needs to lock the file size in order to determine the end of the file, which can block other threads from writing to the file. 

So while I agree that the Linux mantra that "syscalls are cheap" is true if those syscalls don't actually do any work, I think it also ignores the cost of what some syscalls need to do behind the scenes. 

Cheers, Andreas