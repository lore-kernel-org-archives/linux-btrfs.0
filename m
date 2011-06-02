From: "Fajar A. Nugraha" <list@fajar.net>
Subject: Re: Announcing btrfs-gui
Date: Thu, 2 Jun 2011 15:31:16 +0700
Message-ID: <BANLkTin_2u0VmmAJXVKnA_s3LuCkoKt29Q@mail.gmail.com>
References: <20110601232058.GA22619@carfax.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: Btrfs mailing list <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20110601232058.GA22619@carfax.org.uk>
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Jun 2, 2011 at 6:20 AM, Hugo Mills <hugo@carfax.org.uk> wrote:
> =A0 Over the last few weeks, I've been playing with a foolish idea,
> mostly triggered by a cluster of people being confused by btrfs's fre=
e
> space reporting (df vs btrfs fi df vs btrfs fi show). I also wanted a=
n
> excuse, and some code, to mess around in the depths of the FS data
> structures.
>
> =A0 Like all silly ideas, this one got a bit out of hand, and seems t=
o
> have turned into something vaguely useful. I'm therefore pleased to
> announce the first major public release of btrfs-gui[1]: a point-and-
> click tool for managing btrfs filesystems.
>
> =A0 The tool currently can scan for and list btrfs filesystems and th=
e
> volumes they live on. It can show the allocation and usage of data in
> a selected filesystem, categorised by use, replication, and device. I=
t
> can show and manipulate subvolumes and snapshots: creation, deletion,
> and setting the default.


Some comments:
(1) Currently it needs to be run from the directory where it's
downloaded, even after a "python3 setup.py install". When run from
other directory, it bails with

Traceback (most recent call last):
  File "/usr/local/bin/btrfs-gui", line 5, in <module>
    btrfsgui.main.main()
  File "/usr/local/lib/python3.2/dist-packages/btrfsgui/main.py", line
24, in main
    subproc =3D init_root_process(options)
  File "/usr/local/lib/python3.2/dist-packages/btrfsgui/sudo.py", line
31, in init_root_process
    stdin=3Dsubprocess.PIPE, stdout=3Dsubprocess.PIPE)
  File "/usr/lib/python3.2/subprocess.py", line 736, in __init__
    restore_signals, start_new_session)
  File "/usr/lib/python3.2/subprocess.py", line 1330, in _execute_child
    raise child_exception_type(errno_num, err_msg)
OSError: [Errno 2] No such file or directory: './btrfs-gui-helper'

Is this intentional?

(2) When showing space usage for a single-device FS, selecting "Show
unallocated space as raw space", why is the top and bottom graph
different? Shouldn't it be the same, since there's only one device?

(3) Not directly related to btrfs-gui, but I've been wondering what's
the correct way to SHOW the current default subvolume?

--=20
=46ajar
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
