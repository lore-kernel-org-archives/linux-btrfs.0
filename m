From: Paul Komkoff <i@stingr.net>
Subject: Re: btrfs fallocate woes
Date: Thu, 14 Jan 2010 20:33:30 +0000
Message-ID: <715ea5c11001141233i78410267qc4d0767f5b7b8250@mail.gmail.com>
References: <715ea5c11001140328g6198447axce1ba884a6e6fb96@mail.gmail.com>
	 <aday6k0lhpx.fsf@roland-alpha.cisco.com>
	 <20100114192035.GC23810@think>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: Chris Mason <chris.mason@oracle.com>,
	Roland Dreier <rdreier@cisco.com>, Paul Komkoff <i@stingr.net>,
	linux-btrfs <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20100114192035.GC23810@think>
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Jan 14, 2010 at 7:20 PM, Chris Mason <chris.mason@oracle.com> wrote:
> The file size should still be 4 bytes I think, even if we allocate 4096.

Yes, to clarify - I changed the code to be
  fallocate(fd, 0, 0, 4);
and then
  posix_fallocate(fd, 0, 4);

(which is the same I guess)

and tried it on different filesystems, and on btrfs I ended up with
entire block (of zeroes).
If it's fixed in latest tree it's fine, I guess that fix isn't in
fedora's 2.6.32.3
-- 
This message represents the official view of the voices in my head
