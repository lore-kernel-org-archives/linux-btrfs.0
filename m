From: Gordan Bobic <gordan@bobich.net>
Subject: Re: hard links across snapshots/subvolumes are actually a bad idea.
Date: Thu, 25 Nov 2010 08:00:15 +0000
Message-ID: <4CEE178F.6090902@bobich.net>
References: <AANLkTinMrCMQhnmrG6P_Xro+dFob=-gsatPTR2oiRXqr@mail.gmail.com>	<4CED9FCC.9080804@bobich.net>	<AANLkTik7u_eexi++vDCsRh0oa74Q4F1Jjzt_mNn+=MZC@mail.gmail.com>	<4CEDAB6D.6090409@bobich.net> <AANLkTikW65-Bozsog1exV2G=96DcGR0thSok1NJP4pN9@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
To: BTRFS MAILING LIST <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <AANLkTikW65-Bozsog1exV2G=96DcGR0thSok1NJP4pN9@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

cwillu wrote:
>>>> One thing I would like to see is copy-on-write hard-links. The hard-links
>>>> that span snapshots should be possible, but they should be copy-on-write,
>>>> i.e. as soon as hard-linked file that spans snapshots is written, the
>>>> snapshot that wrote it should have it's own forked copy henceforth.
>>> There are sym-links, hard-links, and ref-links.  Cross device symlinks
>>> are trivial.  Cross device hardlinks are evil.  Cross device ref-links
>>> are just plain smart (and are at least partitially implemented in
>>> btrfs;  does bcp work across subvolumes?).  :)
>> Last time I asked a similar question, there was no equivalent thing to COW
>> hard-links, across snapshots or otherwise. Hard-links spanning physical
>> devices don't make sense. Hard-links spanning snapshots, however, do. In
>> fact, I would intuitively expect that a snapshot contains only COW
>> hard-links which would get COW-ed from both the head and the snapshot.
> 
> "COW hardlinks" are ref-links (as far as I'm concerned).  I said
> partially implemented, because that's exactly what a snapshot is.  I'm
> just not certain whether bcp works across subvolumes or not.  An
> actual hardlink (i.e., all writes appear in all hardlinks) across any
> file-system-like-structure (including subvolumes and snapshots) is
> insane, for the reasons that I'm sure David offered to explain.

My understanding is that inode numbers on the "same" files are different 
between snapshots. If that is the case then it is not good enough for 
the use-case I was talking bout. Hard-links share inode numbers. Do 
ref-links?

Gordan
