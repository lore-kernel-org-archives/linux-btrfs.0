From: Arne Jansen <sensille@gmx.net>
Subject: Re: [PATCH] [RFC] Add btrfs autosnap feature
Date: Mon, 05 Mar 2012 08:18:28 +0100
Message-ID: <4F5468C4.5090401@gmx.net>
References: <1330484376-16178-1-git-send-email-anand.jain@oracle.com>	<1330484376-16178-2-git-send-email-anand.jain@oracle.com>	<CAE5mzvjiL+81AsSspTrE1A1BBiL27zJ1qK1oqCF27oL+-CG9Mw@mail.gmail.com>	<4F54625E.6040003@oracle.com> <CAG1y0sdy0p2D4AHBcHgiYxPYknbW8O3xgCuvwKy==sWnW5BJAg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: Anand Jain <Anand.Jain@oracle.com>, cwillu <cwillu@cwillu.com>,
	linux-btrfs@vger.kernel.org, hugo@carfax.org.uk,
	chris.mason@oracle.com
To: "Fajar A. Nugraha" <list@fajar.net>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <CAG1y0sdy0p2D4AHBcHgiYxPYknbW8O3xgCuvwKy==sWnW5BJAg@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On 05.03.2012 08:07, Fajar A. Nugraha wrote:
> On Mon, Mar 5, 2012 at 1:51 PM, Anand Jain <Anand.Jain@oracle.com> wrote:
>>
>>> (notably the direct modification of
>>> crontab files, which is considered to be an internal detail if I
>>> understand correctly, and I'm fairly certain is broken as written),
>>
>>
>>  I did came across that point of view however, using crontab cli in the
>>  program wasn't convincing either, (library call would have been better).
>>  any other better ways to manage cron entries ?
>>
> 
> /etc/cron.{d,daily,hourly} ?
> 

An alternative would be to have an hourly (or minutely) fixed cronjob
and let the tool decide whether any snapshots have to be created. This
way you don't have to mess around with the crontab.
