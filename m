From: Amedee Van Gasse <amedee@vangasse.eu>
Subject: Re: Announcing btrfs-gui
Date: Sat, 12 Nov 2011 01:24:57 +0100
Message-ID: <4EBDBCD9.8060009@vangasse.eu>
References: <20110601232058.GA22619@carfax.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Cc: hugo@carfax.org.uk
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20110601232058.GA22619@carfax.org.uk>
List-ID: <linux-btrfs.vger.kernel.org>

On 02-06-11 01:20, Hugo Mills wrote:

*snip*

>     Like all silly ideas, this one got a bit out of hand, and seems to
> have turned into something vaguely useful. I'm therefore pleased to
> announce the first major public release of btrfs-gui[1]: a point-and-
> click tool for managing btrfs filesystems.
>
>     The tool currently can scan for and list btrfs filesystems and the
> volumes they live on. It can show the allocation and usage of data in
> a selected filesystem, categorised by use, replication, and device. It
> can show and manipulate subvolumes and snapshots: creation, deletion,
> and setting the default. For those with servers to manage, it also has
> the ability to ssh into a remote machine, and manage its filesystems
> remotely (so you don't have to have X installed on your servers just
> to use btrfs-gui on them).

*snip*

>     Unless the traffic gets too high-volume, or unless someone
> important objects, I'm going to suggest that bug reports should go to
> this list for now (cc'd me, if you like). Note that this isn't an
> "offical" btrfs project -- it's just something I knocked together on
> my own.


I seem to have stumbled upon a bug.
During install, Ubuntu gives the user the option to use btrfs as the 
root filesystem. It automatically creates two subvolumes, @ (for /) and 
@home (for /home, only if no other partition is used for /home), like this:

mount | grep btrfs
/dev/sda6 on / type btrfs (rw,subvol=@)
/dev/sda6 on /home type btrfs (rw,subvol=@home)
/dev/sda6 on 
/tmp/btrfs-gui-kl6zx1/12624/eba4f1e9-5b55-4e14-abb8-5a3cf3625c56 type 
btrfs (rw,subvolid=0)

When gtrfs-gui scans for filesystems, it gives the error
Root helper exception: b'@' is not JSON serializable

This is the relevant console output:

Helper: found label None, UUID eba4f1e9-5b55-4e14-abb8-5a3cf3625c56
Helper: found dev 1 = /dev/sda6
Helper: Created private directory /tmp/btrfs-gui-kl6zx1
Helper: Mounted filesystem UUID=eba4f1e9-5b55-4e14-abb8-5a3cf3625c56 at 
/tmp/btrfs-gui-kl6zx1/12624/eba4f1e9-5b55-4e14-abb8-5a3cf3625c56
Traceback (most recent call last):
   File "/usr/local/lib/python3.2/dist-packages/btrfsgui/hlp/helper.py", 
line 40, in main
     COMMANDS[command](parameters)
   File "/usr/local/lib/python3.2/dist-packages/btrfsgui/hlp/subvol.py", 
line 126, in sv_list
     sys.stdout.write(json.dumps(res))
   File "/usr/lib/python3.2/json/__init__.py", line 224, in dumps
     return _default_encoder.encode(obj)
   File "/usr/lib/python3.2/json/encoder.py", line 188, in encode
     chunks = self.iterencode(o, _one_shot=True)
   File "/usr/lib/python3.2/json/encoder.py", line 246, in iterencode
     return _iterencode(o, 0)
   File "/usr/lib/python3.2/json/encoder.py", line 170, in default
     raise TypeError(repr(o) + " is not JSON serializable")
TypeError: b'@' is not JSON serializable


Kind regards,
Amedee Van Gasse
amedee@vangasse.eu
