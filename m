From: "Jeff Schroeder" <jeffschroed@gmail.com>
Subject: Re: Mount btrfs from initramfs as /
Date: Fri, 22 Aug 2008 08:01:39 -0700
Message-ID: <c24352ca0808220801x69adae88s286dca6811fed2c4@mail.gmail.com>
References: <loom.20080822T144041-753@post.gmane.org>
Reply-To: jeffschroeder@computer.org
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-btrfs@vger.kernel.org
To: "Paul Schyska" <pschyska@googlemail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <loom.20080822T144041-753@post.gmane.org>
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Aug 22, 2008 at 7:52 AM, Paul Schyska <pschyska@googlemail.com> wrote:
...snip...
> P.S.: I dont have an UUID symlink for /dev/sda3, as I don't know how to find out
> the UUID of the new volume. Thats why I didn't specify UUID in fstab but
> /dev/sda3 device.

You can find out the UUID with either of these commands
# blkid /dev/sda3
# vol_id -u /dev/sda3

-- 
Jeff Schroeder

Don't drink and derive, alcohol and analysis don't mix.
http://www.digitalprognosis.com
