From: "Gregory Maxwell" <gmaxwell@gmail.com>
Subject: Re: Checksum and transform layering
Date: Thu, 6 Nov 2008 11:42:36 -0500
Message-ID: <e692861c0811060842h5ca74e21t799f8321f4fe36c3@mail.gmail.com>
References: <e692861c0811052234h704c938es20b562123aa4fe9b@mail.gmail.com>
	 <82ej1oiznq.fsf@mid.bfk.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: linux-btrfs@vger.kernel.org
To: "Florian Weimer" <fweimer@bfk.de>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <82ej1oiznq.fsf@mid.bfk.de>
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Nov 6, 2008 at 11:31 AM, Florian Weimer <fweimer@bfk.de> wrote:
> * Gregory Maxwell:
>
>> I noticed in the compression support that the checksum is over the
>> uncompressed data.
>>
>> While this has the advantages that the checksum does not have to be
>> changed as transformations are changed and the system might catch
>> errors in the compression layer, this design decision will be
>> problematic if/when encryption is supported:  Plaintext checksums
>> would leak substantial amounts of information about the content of
>> files.
>
> Would this be an issue if metadata (including file names) were
> encrypted as well?

If the checksum is encrypted, no, at least not obviously. But as I've
mentioned if the checksum is encrypted then you can't scrub the FS for
checksum errors without the keys.

A lack of metadata encryption would be another possible information
leak, but at least it's one which can probably be understood by users.
It would be nice if subvolume level encryption provided metadata
encryption.   If metadata is encrypted but block checksums are
unencrypted and on plaintext then information will leak about the
files, even if the checksum is replaced with an unkeyed or
non-secret-keyed cryptographic hash, a secret-keyed hash is equivalent
to an encrypted checksum.
