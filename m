From: Daniel J Blueman <daniel.blueman@gmail.com>
Subject: Re: file/extent checksums for dedup/sync...
Date: Wed, 27 Jan 2010 13:23:28 +0000
Message-ID: <6278d2221001270523r13ab8973v927c8b60da181c9c@mail.gmail.com>
References: <6278d2221001270410k1493582fvccdf23bed14cc0ff@mail.gmail.com>
	 <87pr4venm4.fsf@basil.nowhere.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: Andi Kleen <andi@firstfloor.org>,
	Linux BTRFS <linux-btrfs@vger.kernel.org>,
	Linux Kernel <linux-kernel@vger.kernel.org>
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1754648Ab0A0NXc@vger.kernel.org>
In-Reply-To: <87pr4venm4.fsf@basil.nowhere.org>
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Jan 27, 2010 at 12:30 PM, Andi Kleen <andi@firstfloor.org> wrote:
> Daniel J Blueman <daniel.blueman@gmail.com> writes:
>
>> For purposes of data deduplication and data synchronisation, it would
>> be a powerful tool to expose file data checksums.
>>
>> Since eg BTRFS uses the crc32c algorithm [1], it's possible to compute
>> the file's overall CRC from the accumulation of the CRCs from all it's
>> extents' CRCs.
>>
>> For now, exposing this via an IOCTL may be sufficient, though any
>> ideas for introducing it in a more standard way? (it's a pity that
>> when stat64 was introduced, reserved fields weren't added)
>
> The problem of doing it in any "standard way" is that it would
> hard code the way the file system does checksums in the applications.
> So the file system could never change it without breaking
> user space.

I guess the filesystem would need to express this in the resulting
data-structure, eg:
 - type 1 corresponds to using the crc32c algorithm with starting seed
N and accumulating ascending over data extents, padding with modulus
remainder or sparse holes with 0
 - type 2 etc

The next question, is does filesystem (eg BTRFS) compression come
before or after checksumming?
-- 
Daniel J Blueman
