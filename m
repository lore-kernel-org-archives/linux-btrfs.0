From: dima <dolenin@parallels.com>
Subject: Re: Snapshot rollback
Date: Tue, 25 Oct 2011 17:54:37 +0900
Message-ID: <4EA6794D.3000608@parallels.com>
References: <4EA46E3A.9090307@cfl.rr.com> <loom.20111024T071806-3@post.gmane.org> <CAG1y0sfmnD8W7an-7HicwfH0HuzJA4wnOLq90qn5iTJmEs4v0w@mail.gmail.com> <loom.20111024T101858-236@post.gmane.org> <CAG1y0sc_2+NZm0o8Ng_kyjWgZLZZ3SaJ3=5-0SG2_4r1tKjwoQ@mail.gmail.com> <loom.20111025T034412-244@post.gmane.org> <CAG1y0sfk3TozN0-das7et0StL5pcFFLv4tn3XHKxG56xftuPEA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"; format=flowed
Cc: <linux-btrfs@vger.kernel.org>
To: "Fajar A. Nugraha" <list@fajar.net>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <CAG1y0sfk3TozN0-das7et0StL5pcFFLv4tn3XHKxG56xftuPEA@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On 10/25/2011 05:01 PM, Fajar A. Nugraha wrote:
 > On Tue, Oct 25, 2011 at 9:00 AM, dima<dolenin@parallels.com>  wrote:
 >> Fajar A. Nugraha<list<at>  fajar.net>  writes:
 >>
 >>> AFAIK you have three possible ways to use /boot on btrfs:
 >>>
 >>> (1) put /boot on subvolid=0, don't change the default subvolume. That
 >>> works, but all your snapshot/subvols will be visible under /boot. Some
 >>> people might not want that for estetic reason.
 >>
 >> Hi Fajar,
 >> I think I am doing just this, but my subvolumes are not visible 
under /boot. I
 >> have all my subvolumes set up like this:
 >> /path/to/subvolid_0/boot<  a simple directory bind-mounted to /
 >> /path/to/subvolid_0/__active<  my / subvolume
 >> /path/to/subvolid_0/__home<  my /home subvolume
 >
 > Actually with that setup you're using option (3) that I described.
 >
 > That means all your subvolumes is still visible under
 > /path/to/subvolid_0/, right? I'm not sure how well grub can manage
 > this. Probably it can't, so you'd have to manage boot entries
 > manually.

Yes, you are right. I can see all subvolumes under /path/to/subvolid_0
By the way grub2 can manage this setup correctly and generate the right 
menu entries without any problems.

But - /boot is not in its own subvolume in this setup. I think this is 
the reason it works out of the box.

Thank you for your explanations.
I can see if I can make it work with /boot in its own subvolume.

~d
