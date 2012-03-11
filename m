From: qasdfgtyuiop <qasdfgtyuiop@gmail.com>
Subject: Re: kernel BUG at fs/btrfs/transaction.c:1337!
Date: Sun, 11 Mar 2012 09:54:07 +0800
Message-ID: <CAMtaSwTRYm-qp0xPw_Rdc5VcXLzLZ-p0jqt6ZGSnmWp2-cm8Jw@mail.gmail.com>
References: <CAMtaSwQUG2ovM8Yv_2+kLNMQbtMzwDq1pgd9PsMC3xYn2b6xmw@mail.gmail.com>
 <20120310231009.GM4334@twin.jikos.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: dave@jikos.cz, qasdfgtyuiop <qasdfgtyuiop@gmail.com>,
	btrfs <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20120310231009.GM4334@twin.jikos.cz>
List-ID: <linux-btrfs.vger.kernel.org>

It seems not.  The oops occurs when I'm surfing the Internet using
chromium and downloading and uploading using transmisson.  Suddenly it
switched to console and printed these lines.  My root filesystem / is
on a 16GB SSD whoes device file is /dev/sdb1.  The mount option is
ssd,compress.

On Sun, Mar 11, 2012 at 7:10 AM, David Sterba <dave@jikos.cz> wrote:
> This is an IO error during transaction commit. Did you see any disk
> error messages before the oops?
>
>
> david
>
> On Sat, Mar 10, 2012 at 06:26:02PM +0800, qasdfgtyuiop wrote:
>> [11558.528460] RAX: 00000000fffffffb
>
> 0xFB == -EIO
