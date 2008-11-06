From: "Gregory Maxwell" <gmaxwell@gmail.com>
Subject: Checksum and transform layering
Date: Thu, 6 Nov 2008 01:34:55 -0500
Message-ID: <e692861c0811052234h704c938es20b562123aa4fe9b@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

I noticed in the compression support that the checksum is over the
uncompressed data.

While this has the advantages that the checksum does not have to be
changed as transformations are changed and the system might catch
errors in the compression layer, this design decision will be
problematic if/when encryption is supported:  Plaintext checksums
would leak substantial amounts of information about the content of
files.  The system could be switched to a keyed cryptographic hash,
but then you will have made the "checksum" part of the file system
intimately tied to the cryptographic part (including having to deal
with key management, not being able to check blocks with keys that are
currently unavailable which would break automated scrubbing), and a
potential source of security problems. I think there is currently
enough space to store per-block a 64 bit checksum for integrity, a
64bit nonce for uniqueness, and a 128bit cryptographic hash for
authentication.

A minor additional point, by applying the checksum before other
transformations you lose the straightforward algebraic relationship
with the disk bits and check data. One advantage checksums and RS
codes have over cryptographic hashes is that advanced recovery tools
could be created which utilize all available data (multiple mirror
blocks, raid data, known corrupted sectors from the disk, and multiple
check) to provide maximum likelihood decodes, for cases where
known-perfect decoding is not possible, and the data can't be
otherwise replaced. I don't know if anyone will bother building such
tools, but maybe someone cares.
