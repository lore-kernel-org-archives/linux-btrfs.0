From: Josef Bacik <josef@redhat.com>
Subject: Re: Boot speed/mount time regression with 3.4.0-rc2
Date: Fri, 13 Apr 2012 09:47:16 -0400
Message-ID: <20120413134716.GB1923@localhost.localdomain>
References: <20120410151645.GC2296@localhost.localdomain>
 <CAFDW0j+=qe49pX3frjEoozOMz-gKKxqJ+jeeTgyXEskDL_9W8w@mail.gmail.com>
 <20120411170422.GA2506@localhost.localdomain>
 <CAFDW0jJZ16jPn766fdn3Hm=WWkR71n0kJapfPZzgHd3o71b1hQ@mail.gmail.com>
 <20120412133747.GE1924@localhost.localdomain>
 <20120412142349.GI1924@localhost.localdomain>
 <CAFDW0jJq46TXa_a1soYESgjZosBDM8razvT271S3_SoyQeBbSA@mail.gmail.com>
 <CAE5mzvjJ+fuixm=OpKua6t6s6sncz1RGwXem8D6ZS=jDRDQ3+g@mail.gmail.com>
 <CAFDW0jL4TTWtqMw4f_1WpQuEU7Q1SoTUo_rBVGcdHt008Sx1Zw@mail.gmail.com>
 <CAFDW0jKMEQ+oMN41euh1cMy4h+6Qntt5UL9+0HZw4r9SpDJVvQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: cwillu <cwillu@cwillu.com>, Josef Bacik <josef@redhat.com>,
	Calvin Walton <calvin.walton@kepstin.ca>,
	linux-btrfs@vger.kernel.org, Chris Mason <chris.mason@oracle.com>
To: Ahmet Inan <ainan@mathematik.uni-freiburg.de>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <CAFDW0jKMEQ+oMN41euh1cMy4h+6Qntt5UL9+0HZw4r9SpDJVvQ@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Apr 13, 2012 at 02:26:19PM +0200, Ahmet Inan wrote:
> On Fri, Apr 13, 2012 at 1:22 PM, Ahmet Inan
> <ainan@mathematik.uni-freiburg.de> wrote:
> > On Fri, Apr 13, 2012 at 8:49 AM, cwillu <cwillu@cwillu.com> wrote:
> >>> dmesg and fstab attached as requested.
> >>
> >> Need dmesg after you've hit alt-sysrq-w a couple times during the slow period.
> >
> > here.
> >
> > i guess i should also increase dmesg history size next time.
> > other than the slow boot, everything seems normal after 10-20minutes.
> >
> > fyi: the space_cache option is not really helping with those
> > twenty computers. the one thing i observed is, that sometimes
> > they reboot fast and only to reboot slow again after that.
> 
> sorry for spaming the list with my dmesg files,
> please tell me, how i could do better.
> 
> here a more complete dmesg.

Hrm so you are getting blocked task warnings just trying to mount the
filesystem, so either your disk is really really really slow or there's
something bigger going on.  Let me think about this some and I'll get back to
you.

Josef

