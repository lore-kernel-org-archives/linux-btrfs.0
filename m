From: Chris Mason <chris.mason@oracle.com>
Subject: Re: btrfs filesystem df not working
Date: Tue, 12 Oct 2010 20:43:32 -0400
Message-ID: <20101013004332.GK22691@think>
References: <AANLkTik-414saDjSZFtEKWn4h7zSbbLBqa_0S+uf4SQR@mail.gmail.com>
 <AANLkTi=1VgjsZoJqzkp-zto3vAMUThh7TN054xQ1mpEu@mail.gmail.com>
 <AANLkTinYN+b=5qU_+pC_O6OK96JXez8QQeifdzC8dkCK@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Cc: cwillu <cwillu@cwillu.com>, linux-btrfs@vger.kernel.org
To: Leonidas Spyropoulos <artafinde@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <AANLkTinYN+b=5qU_+pC_O6OK96JXez8QQeifdzC8dkCK@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Oct 12, 2010 at 02:45:19PM +0100, Leonidas Spyropoulos wrote:
> On Tue, Oct 12, 2010 at 2:43 PM, cwillu <cwillu@cwillu.com> wrote:
> > On Tue, Oct 12, 2010 at 4:12 AM, Leonidas Spyropoulos
> > <artafinde@gmail.com> wrote:
> >> The above command is not working on my system.
> >> Information:
> >> btrfs f df /media/data
> >
> > btrfs f isn't unique; =A0fi is the minimum to specify "filesystem"
> >
> I tried even with btrfs filesystem df /media/data
> and same results.

Does strace give us any clues?

-chris

--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
