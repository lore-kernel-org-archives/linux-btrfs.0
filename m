From: Ryota Ozaki <ozaki.ryota@gmail.com>
Subject: Re: How to know the origin of a snapshot
Date: Fri, 21 Oct 2011 23:25:07 +0900
Message-ID: <CAKrYomhnxsqs07BF7RgF_uXLE9N15V3mWY+HA81OKAAAGKFcew@mail.gmail.com>
References: <CAKrYomhcMnaaBjhuATGbiMGTQ+uFBiuzwY2HgubeEeY0PA=sHw@mail.gmail.com>
 <4EA15D86.6060601@jan-o-sch.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-btrfs@vger.kernel.org
To: Jan Schmidt <list.btrfs@jan-o-sch.net>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4EA15D86.6060601@jan-o-sch.net>
List-ID: <linux-btrfs.vger.kernel.org>

Hi Jan.

Thank your for answering.

On Fri, Oct 21, 2011 at 8:54 PM, Jan Schmidt <list.btrfs@jan-o-sch.net> wrote:
> Hi,
>
> On 21.10.2011 13:02, Ryota Ozaki wrote:
>> Is there a way to know relations between subvolume and snapshot?
>> For example, can we know a subvolume from a given snapshot which
>> stems from it? For another example, can we get a list of snapshots
>> from a subvolume?
>
> Currently, there's no such relationship. I plan adding a stems-from
> relation in order to support incremental btrfs sends, but that's not
> thought to an end, yet.

Hope it comes early :-) I can help as a tester then.

>
> You can get along with a simple name scheme for the meantime.

Right, but I want to know relations without such scheme, so I hope
to get them from btrfs itself.

  ozaki-r

>
> -Jan
>
