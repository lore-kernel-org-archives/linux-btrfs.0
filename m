From: Victor Stinner <victor.stinner@haypocalc.com>
Subject: Re: Issues with KVM
Date: Mon, 25 Jul 2011 16:04:49 +0200
Message-ID: <4E2D7801.80207@haypocalc.com>
References: <4E29D318.7050602@haypocalc.com> <CAGAVQTGdEQdS+rE-D=fd4GXgaufpdR6J5xgNUjRa+N402Ge5-g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <CAGAVQTGdEQdS+rE-D=fd4GXgaufpdR6J5xgNUjRa+N402Ge5-g@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On 22/07/2011 21:59, C Anthony Risinger wrote:
 > is the disk's cache mode set to none [or maybe writeback]
 > (virtmanager)?

I tested various options: the most important is the cache mode.

cache=none is a little bit better than cache=default (writethrough), but 
there is an huge difference using cache=unsafe. This option is not 
supported by virt-manager, but by kvm. Using cache=unsafe, the 
installation of FreeBSD is ~100x faster:

  - cache=default: write at 1 to 8 KB/sec
  - cache=none: write at 40 KB/sec
  - cache=unsafe: write at 1200 KB/sec

According to agraf__ on IRC (#kvm on FreeNode), the cache mode has the 
following effect:

  - cache=writethrough calls fsync() after every write()
  - cache=none uses O_DIRECT
  - cache=writeback calls fsync() when the guest issues a barrier() 
(don't use O_DIRECT)
  - cache=unsafe doesn't do any fsync() (but don't use O_DIRECT)

I still have to test writeback ;-)

I found another mail thread, of last summer (July 2010), which is 
exactly the same problem that I had: "BTRFS: Unbelievably slow with 
kvm/qemu" on this mailing list. It contains another advice:

"Make sure you build your file system with "mkfs.btrfs -m single -d 
single /dev/whatever". You may well be writing duplicate copies of 
everything."

http://lkml.org/lkml/2010/7/12/5

--

FreeBSD installation in VirtualBox is as fast (or maybe a little bit 
slower) than the installation in kvm using cache=unsafe. I suppose that 
VirtualBox uses something like cache=unsafe or cache=writeback.

Victor
