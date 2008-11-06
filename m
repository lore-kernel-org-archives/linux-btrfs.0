From: "Gregory Maxwell" <gmaxwell@gmail.com>
Subject: Re: Checksum and transform layering
Date: Thu, 6 Nov 2008 09:58:53 -0500
Message-ID: <e692861c0811060658n27427188k4cb6c63443bf2221@mail.gmail.com>
References: <e692861c0811052234h704c938es20b562123aa4fe9b@mail.gmail.com>
	 <1225982445.15281.15.camel@think.oraclecorp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: linux-btrfs@vger.kernel.org
To: "Chris Mason" <chris.mason@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1225982445.15281.15.camel@think.oraclecorp.com>
List-ID: <linux-btrfs.vger.kernel.org>

Thanks for entertaining my comments.

On Thu, Nov 6, 2008 at 9:40 AM, Chris Mason <chris.mason@oracle.com> wrote:
> For encryption we have a few choices.  We can checksum the encrypted
> blocks and disallow compression, or we can use a stronger checksum.
[snip]

The first sounds viable, although mutually exclusive features aren't
very user-friendly.

The latter would need to be a probably need to be a secret-keyed HMAC
to prevent watermarking attacks and information leakage, I don't think
simply salting with the sector number or other public information
would be sufficient: I could still take your encrypted disk and answer
the question "Does Chris have block X?" by checking the checksums.

But if the checksum is a keyed transform we can't sweep the
file-system for bit-rot without having all the keys available.  I
expect the common use case for encrypted btrfs is similar to eCryptfs
where each user may have their own keys which are only available when
they are logged in (single key whole disk encryption can still be
easily done with a dmcrypt).  So having all the keys at once may not
be especially realistic.  But being able to scan for failing blocks is
important in catching errors before there is too much damage.
