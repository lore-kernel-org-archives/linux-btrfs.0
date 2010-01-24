From: mail ignored <0.bugs.only.0@gmail.com>
Subject: when/why to use diffferent raid values for btrfs data & metadata?
Date: Sat, 23 Jan 2010 20:02:33 -0800
Message-ID: <c67eed301001232002o2f89f2fct4dc9fe8516b976bc@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

Just getting started with btrfs.

I understand that btrfs stores data/metadata in two different tree
structures =96 one for file/directory names, and one for data blocks.

Reading @,

 http://btrfs.wiki.kernel.org/index.php/Using_Btrfs_with_Multiple_Devic=
es
  Use raid10 for both data and metadata
    mkfs.btrfs -m raid10 -d raid10 /dev/sdb /dev/sdc /dev/sdd /dev/sde

and @,

 "Churning Butter(FS): An Interview with Chris Mason"
  http://www.linux-mag.com/id/7329

    CM Today you can do this:
    mkfs.btrfs -m raid1 -d raid10 /dev/sda /dev/sdb /dev/sdc /dev/sdd
And you=92ll get metadata on raid1 and data on raid10. The raid10 will
use all four drives and the raid1 will use two drives at a time. Yes,
btrfs allows you to pick different values for data or metadata.

The fact that I *can* setup data & metadata differently is clear.  But
I'm not at all clear *why* I'd want to, or what the advantages are.
I'd guess it's a balance/combination of performance & resiliency.

Naively "-m raid10 -d raid10" seems to make the most sense -- if i
have it, use it.

Are there any benchmarks, guidelines or recommendations?
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
