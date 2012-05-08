From: Martin <m_btrfs@ml1.co.uk>
Subject: Re: btrfs and 1 billion small files
Date: Tue, 08 May 2012 17:46:13 +0100
Message-ID: <jobikm$j9b$1@dough.gmane.org>
References: <711331964.2091.1336382892940.JavaMail.root@zimbra.interconnessioni.it> <4FA7AC73.5080903@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4FA7AC73.5080903@gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On 07/05/12 12:05, vivo75@gmail.com wrote:
> Il 07/05/2012 11:28, Alessio Focardi ha scritto:
>> Hi,
>>
>> I need some help in designing a storage structure for 1 billion of
>> small files (<512 Bytes), and I was wondering how btrfs will fit in
>> this scenario. Keep in mind that I never worked with btrfs - I just
>> read some documentation and browsed this mailing list - so forgive me
>> if my questions are silly! :X

> Are you *really* sure a database is *not* what are you looking for?

My thought also.


Or:

1 billion 512 byte files... Is that not a 512GByte HDD?

With that, use a database to index your data by sector number and
read/write your data direct to the disk?

For that example, your database just holds filename, size, and sector.


If your 512 byte files are written and accessed sequentially, then just
use a HDD and address them by sector number from a database index. That
then becomes your 'filesystem'.

If you need fast random access, then use SSDs.


Plausible?

Regards,
Martin


