From: Josef Bacik <jbacik@redhat.com>
Subject: Re: [PATCH] fix lockdep warnings
Date: Fri, 31 Oct 2008 08:03:44 -0400
Message-ID: <20081031120343.GB31107@unused.rdu.redhat.com>
References: <20081030143243.GA31107@unused.rdu.redhat.com> <b82a89170810302052k4c310318l1c86988ca18722d9@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Josef Bacik <jbacik@redhat.com>, linux-btrfs@vger.kernel.org
To: Niraj kumar <niraj17@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <b82a89170810302052k4c310318l1c86988ca18722d9@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Oct 31, 2008 at 09:22:17AM +0530, Niraj kumar wrote:
> Josef,
> 
> I saw this yesterday, but not sure how to reproduce it.
> Is this the same warning that this patch fixes ?
>

Yup thats the warning this patch is supposed to fix.  You didn't get this
warning with this patch did you?  Thanks,

Josef
 
