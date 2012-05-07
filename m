From: David Sterba <dave@jikos.cz>
Subject: Re: btrfs and 1 billion small files
Date: Mon, 7 May 2012 17:13:58 +0200
Message-ID: <20120507151358.GE19331@twin.jikos.cz>
References: <1913174825.1910.1336382310577.JavaMail.root@zimbra.interconnessioni.it>
 <711331964.2091.1336382892940.JavaMail.root@zimbra.interconnessioni.it>
Reply-To: dave@jikos.cz
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-btrfs@vger.kernel.org
To: Alessio Focardi <alessiof@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <711331964.2091.1336382892940.JavaMail.root@zimbra.interconnessioni.it>
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, May 07, 2012 at 11:28:13AM +0200, Alessio Focardi wrote:
> I tough about compression, but is not clear to me the compression is
> handled at the file level or at the block level.

I don't recommend using compression for your expected file size range.
Unless the files are highly compressible (50-75%, which I don't
expect), the extra cpu processing of compression will make things only
worse.


david
