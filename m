From: Gordan Bobic <gordan@bobich.net>
Subject: Re: hard links across snapshots/subvolumes are actually a bad idea.
Date: Thu, 25 Nov 2010 00:18:53 +0000
Message-ID: <4CEDAB6D.6090409@bobich.net>
References: <AANLkTinMrCMQhnmrG6P_Xro+dFob=-gsatPTR2oiRXqr@mail.gmail.com>	<4CED9FCC.9080804@bobich.net> <AANLkTik7u_eexi++vDCsRh0oa74Q4F1Jjzt_mNn+=MZC@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
To: BTRFS MAILING LIST <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <AANLkTik7u_eexi++vDCsRh0oa74Q4F1Jjzt_mNn+=MZC@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On 11/24/2010 11:57 PM, cwillu wrote:
> On Wed, Nov 24, 2010 at 5:29 PM, Gordan Bobic<gordan@bobich.net>  wrote:
>> On 11/24/2010 10:07 PM, David Nicol wrote:
>>>
>>> I've been thinking about this for a while, from a perspective of how
>>> to make it work by allocating i-node numbers from a global pool, but
>>> yesterday I realized that offering the feature would be a bad idea
>>> because it violates the semantics of file systems.
>>>
>>> I will be happy to expand on that point if anyone disagrees with it.
>>
>> One thing I would like to see is copy-on-write hard-links. The hard-links
>> that span snapshots should be possible, but they should be copy-on-write,
>> i.e. as soon as hard-linked file that spans snapshots is written, the
>> snapshot that wrote it should have it's own forked copy henceforth.
>
> There are sym-links, hard-links, and ref-links.  Cross device symlinks
> are trivial.  Cross device hardlinks are evil.  Cross device ref-links
> are just plain smart (and are at least partitially implemented in
> btrfs;  does bcp work across subvolumes?).  :)

Last time I asked a similar question, there was no equivalent thing to 
COW hard-links, across snapshots or otherwise. Hard-links spanning 
physical devices don't make sense. Hard-links spanning snapshots, 
however, do. In fact, I would intuitively expect that a snapshot 
contains only COW hard-links which would get COW-ed from both the head 
and the snapshot.

Gordan
